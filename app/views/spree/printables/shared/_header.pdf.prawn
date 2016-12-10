im = Rails.application.assets.find_asset(Spree::PrintInvoice::Config[:logo_path])

if im && File.exist?(im.pathname)
  pdf.image im.filename, vposition: :top, height: 50, scale: Spree::PrintInvoice::Config[:logo_scale]
end

pdf.grid([0,3], [1,4]).bounding_box do
  pdf.text Spree.t(printable.document_type, scope: :print_invoice), align: :right, style: :bold, size: 18

  pdf.move_down 2

  pdf.text Spree.t(:invoice_series, scope: :print_invoice, series: "MG1") + " " +
           Spree.t(:invoice_number, scope: :print_invoice, number: printable.number), align: :right

  pdf.move_down 2

  pdf.text Spree.t(:invoice_date, scope: :print_invoice, date: I18n.l(printable.date)), align: :right

  pdf.move_down 2

  pdf.text Spree.t(:invoice_order_number, scope: :print_invoice, number: printable.printable.number), align: :right

  if printable.template == 'return'
    pdf.move_down 2
    pdf.text Spree.t(
      :original_invoice_info,
      scope: :print_invoice,
      number: printable.printable.invoice_number,
      date: I18n.l(printable.printable.invoice_date)
    ), align: :right
  end
end
