require 'rails_helper'
require 'byebug'
describe "Costing report", type: :model do

  before :each do
    @company = create(:company)
    @user = create(:user, company: @company)
    @surgery_file = create(:surgery_file, company: @company, user: @user)
  end

  it "list all cx files" do
    create(:sale_file, company: @surgery_file.company, user: @surgery_file.user)

    report_file_ids = Reports::Costing.all.map(&:id)
    surgery_files_id = [@surgery_file.id]
    expect(report_file_ids).to match_array(surgery_files_id)
  end

  it "filter cx files by date range" do
    date = Date.today + 5.days
    files = Reports::Costing.search(from: date, to: date)
    expect(files.size).to be_equal 1
  end

  it "filter cx files by supplier" do
    supplier = create(:supplier, company: @company)
    purchase_order = create(:surgery_purchase_order, company: @company, user: @user, entity: supplier, file: @surgery_file, state: "Aprobado")
    files = Reports::Costing.search(supplier: @surgery_file.suppliers.sample.name)
    expect(files.size).to be_equal 1
  end

  it "filter cx files by doctor" do
    files = Reports::Costing.search(doctor: @surgery_file.doctor)
    expect(files.size).to be_equal 1
  end

  it "filter cx files by patient" do
    files = Reports::Costing.search(patient: @surgery_file.pacient)
    expect(files.size).to be_equal 1
  end

  it "filter cx files by client" do
    client = create(:client, company: @company)
    @surgery_file.update_columns(entity_id: client.id)
    files = Reports::Costing.search(client: @surgery_file.entity.name)
    expect(files.size).to be_equal 1
  end

  it "product costing must equal the sum of all billed products" do
    #MOVE TO FACTORY BOT
  end
  it "service costing must equal the sum of all billed services" do
    # MOVE TO FACTORY BOT
  end
  it "shipment costing must equal the sum of all purchase orders shipment_cost" do
    # MOVE TO FACTORY BOT
  end
  it "associated expenses must equal the sum of all purchase_orders and sale_orders cash account expeditures" do
    # MOVE TO FACTORY BOT
  end
  it "Total must equal the sum of product, service, shipment costing and associated expenses" do
    # MOVE TO FACTORY BOT
  end

end
