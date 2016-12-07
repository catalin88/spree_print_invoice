font_style = {
  face: "OpenSans",
  size: Spree::PrintInvoice::Config[:font_size]
}

prawn_document(force_download: true) do |pdf|
  pdf.font_families.update("OpenSans" => {
    :normal => Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf"),
    :italic => Rails.root.join("app/assets/fonts/OpenSans-Italic.ttf"),
    :bold => Rails.root.join("app/assets/fonts/OpenSans-Bold.ttf"),
    :bold_italic => Rails.root.join("app/assets/fonts/OpenSans-BoldItalic.ttf")
  })

  pdf.define_grid(columns: 5, rows: 8, gutter: 10)
  pdf.font font_style[:face], size: font_style[:size]

  pdf.repeat(:all) do
    render 'spree/printables/shared/header', pdf: pdf, printable: doc
  end

  # CONTENT
  pdf.grid([0.8,0], [6,4]).bounding_box do

    # buyer/seller block on first page only
    if pdf.page_number == 1
      render 'spree/printables/shared/buyer_seller_block', pdf: pdf, printable: doc
    end

    pdf.move_down 10

    render 'spree/printables/shared/invoice/items', pdf: pdf, invoice: doc

    pdf.move_down 10

    render 'spree/printables/shared/totals', pdf: pdf, invoice: doc

    pdf.move_down 10

    render 'spree/printables/shared/shipment_block', pdf: pdf, printable: doc

    pdf.move_down 30

    pdf.text Spree::PrintInvoice::Config[:return_message], align: :right, size: font_style[:size]
  end

  # Footer
  if Spree::PrintInvoice::Config[:use_footer]
    render 'spree/printables/shared/footer', pdf: pdf
  end

  # Page Number
  if Spree::PrintInvoice::Config[:use_page_numbers]
    render 'spree/printables/shared/page_number', pdf: pdf
  end

  # Canceled
  if Spree::Order.find(doc.printable_id).state == 'canceled'
    render 'spree/printables/shared/cancel', pdf: pdf
  end
end
