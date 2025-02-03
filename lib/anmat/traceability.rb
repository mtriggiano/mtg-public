require 'constants'
module Anmat

	class Traceability
		def initialize(args= {}, environment = :test)
			@environment 			= environment
			@usuario_laboratorio_2	= args[:usuario_laboratorio_2] 	|| '9999999999918'
			@pass_laboratorio_2 	= args[:pass_laboratorio_2] 	 	|| 'Pami1111'
			@gln_laboratorio_2		= args[:gln_laboratorio_2] 	 		|| '9999999999918'

			@usuario_laboratorio_1 	= args[:usuario_laboratorio_1] 		|| 'pruebasws'
			@pass_laboratorio_1 	= args[:pass_laboratorio_1] 		|| 'Clave1234'
			@gln_laboratorio_1 		= args[:gln_laboratorio_1] 			|| 'glnws'

			@gln_drogueria 			= args[:gln_drogueria] 				|| "9999999999925";


		end

		def set_client
			@client = Savon.client(
		        wsdl:  Anmat::URLS[@environment][:wsdl],
		        endpoint: 'https://servicios.pami.org.ar/trazamed.WebService',
		        wsse_auth: ['testwservice', 'testwservicepsw'],
		        namespaces: Anmat::NAMESPACES,
		        namespace_identifier: :ns1,
		        log: true,
		        log_level:  :debug,
		        pretty_print_xml: true,
		        headers: { "Accept-Encoding" => "gzip, deflate", "Connection" => "close" }
		    )
		end

		def responder(response)
			errores = ""
			id_transaccion = ""
			resultado = ""
			transacciones = []
			if response[:return]
				resultado 		= response[:return][:resultado]
				id_transaccion  = response[:return][:codigo_transaccion] || response[:return][:id_transac_asociada]
				transacciones 	= response[:return][:list]
				if response[:return][:errores].is_a?(Array)
					response[:return][:errores].each do |k,v|
						if v.is_a?(Array)
							errores << "Código: " + v['_c_error'].to_s + ". - Descripción: " + v['_d_error'] +".\n"
						else
								errores << v + "-"
						end
					end
				else
					v = response[:return][:errores]
					errores << "Código: " + v[:_c_error].to_s + ". - Descripción: " + v[:_d_error] +".\n"
				end
			end
			return {resultado: resultado, id_transaccion: id_transaccion, transacciones: transacciones, errores: errores}
		end

		def send_medicamentos(args={})
			set_client
			random_serial = rand(1300..99999999)
			body = {
				"arg0" => {
					"f_evento"				=> args[:f_evento] 				|| "20/01/2013" ,
					"h_evento"				=> args[:h_evento] 				|| "13:15",
					"gln_origen"			=> args[:gln_origen] 			|| "glnws",
					#"cuit_origen" 			=> args[:company_cuit] 			|| "20368642682",
					"gln_destino"			=> args[:gln_destino] 			|| "9999999999918",
					"n_remito"				=> args[:n_remito] 				|| "R000100001235",
					"n_factura"				=> args[:n_factura] 			|| "R000100001235",
					"vencimiento"			=> args[:vencimiento] 			|| "01/05/2011",
					"gtin"					=> args[:gtin] 					|| "GTIN2",
					"lote"					=> args[:lote] 					|| "1",
					"numero_serial" 		=> args[:numero_serial] 		|| random_serial,
					"id_evento"				=> args[:id_evento] 			|| "133",
				},
				"arg1" => @usuario_laboratorio_1,
				"arg2" => @pass_laboratorio_1
			}

			response = @client.call(:send_medicamentos, message: body)
			return responder(response.body[:send_medicamentos_response])
		end

		def cancelar_transaccion(id)
			set_client
			body = {"arg0" => id, "arg1" => @usuario_laboratorio_2, "arg2" => @pass_laboratorio_2}
			response = @client.call(:send_cancelac_transacc, message: body)
			return responder(response.body[:send_cancelac_transacc_response])
		end

		def consultar_stock(args={})
			set_client
			body = {
				"arg0" => @usuario_laboratorio_2,
				"arg1" => @pass_laboratorio_2,
        		"arg3" => @gln_laboratorio_2,
				"arg9" => args[:page],
				"arg10" => args[:per_page]
			}
			response =  @client.call(:get_consulta_stock, message: body)
			return responder(response.body[:get_consulta_stock_response])
		end

		def transacciones_no_confirmadas(args={})
			set_client
			body = {
				"arg0" 	=> @usuario_laboratorio_2,
				"arg1" 	=> @pass_laboratorio_2,
				"arg2" 	=> args[:id_transaccion] 			|| -1,
				"arg3" 	=> args[:gln_informador],
				"arg4" 	=> args[:gln_origen],
				"arg5" 	=> args[:gln_destino],
				"arg6" 	=> args[:gtin],
				"arg7" 	=> args[:id_evento]					|| -1,
				"arg8" 	=> args[:fecha_trans_desde],
				"arg9" 	=> args[:fecha_trans_hasta],
        		"arg10" 	=> args[:fecha_ope_dede],
        		"arg11" 	=> args[:fecha_ope_hasta],
				"arg12" 	=> args[:fecha_vencimiento_desde],
				"arg13" 	=> args[:fecha_vencimiento_hasta],
				"arg14" 	=> args[:n_remito],
				"arg15" 	=> args[:n_factura],
				"arg16" 	=> args[:estado_transaccion]		|| -1,
				"arg17" 	=> args[:n_lote],
				"arg18" 	=> args[:n_serie],
        		"arg19"  => args[:page],
        		"arg20"  => args[:per_page]
			}
			response = @client.call(:get_transacciones_no_confirmadas, message: body)
			return responder(response.body[:get_transacciones_no_confirmadas_response])
		end

		def confirmar_transaccion(id_transaccion)
			set_client
			body = {
				arg0: @usuario_laboratorio_2,
				arg1: @pass_laboratorio_2,
				arg: {
					f_operacion: Date.today.to_s,
					p_ids_tranasc: id_transaccion
				}
			}
			response = @client.call(:send_confirma_transacc, message: body)
			return responder(response.body[:send_confirma_transacc_response])
		end

	end
end
