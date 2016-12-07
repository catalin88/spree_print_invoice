Spree::Reimbursement.class_eval do
  # Create a new invoice before transitioning to reimbursed
  #
  state_machine :reimbursement_status, initial: :pending do
    before_transition to: :reimbursed, do: :invoice_for_return
  end

  has_many :inventory_units, through: :return_items
  # Backwards compatibility stuff. Please don't use these methods, rather use the
  # ones on Spree::BookkeepingDocument
  #
  def pdf_file
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.invoice.pdf instead')
    invoice.pdf
  end

  def pdf_filename
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.invoice.file_name instead')
    invoice.file_name
  end

  def pdf_file_path
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.invoice.pdf_file_path instead')
    invoice.pdf_file_path
  end

  def pdf_storage_path(template)
    ActiveSupport::Deprecation.warn('This API has changed: Please use order.{packaging_slip, invoice}.pdf_file_path instead')
    bookkeeping_documents.find_by!(template: template).file_path
  end

  def invoice_for_return
    return if order.return_invoice.present?
    order.bookkeeping_documents.create(template: 'return')
  end
end
