pdf.repeat(:all) do
  pdf.grid([7.5,0], [7.5,4]).bounding_box do
  
    footer_left =  "Întocmit de: VULCAN CATALIN"
    footer_left << "\nScutit de TVA conform art. 310 alin (1) din Legea 227/2015"
    footer_left << "\nFactura circulă fără semnatura și ștampila societății"
    
    footer_right = "www.miculgigant.ro\ncontact@miculgigant.ro"

    data  = []
    #data << [pdf.make_cell(content: Spree.t(:vat, scope: :print_invoice), colspan: 2, align: :center)]
    #data << [pdf.make_cell(content: '', colspan: 2)]
    data << [pdf.make_cell(content: footer_left,  align: :left),
      pdf.make_cell(content: footer_right, align: :right)]

    pdf.table(data, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2]) do
      row(0..2).style borders: []
    end
  end
end
