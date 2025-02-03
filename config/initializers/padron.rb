Padron.setup do |config|
	config.pkey 		= "#{Rails.root}/app/afip/magnus.key"
	config.cert 		= "#{Rails.root}/app/afip/production.crt"
	config.environment 	= :production
	config.cuit 		= "20368642682"
	config.openssl_bin = "/usr/bin/openssl"  
end