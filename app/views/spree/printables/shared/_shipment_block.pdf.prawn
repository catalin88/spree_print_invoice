ship_details = printable.ship_address

pdf.move_down 2

address_cell_shipping = pdf.make_cell(content: Spree.t(:shipping_details, scope: :print_invoice), font_style: :bold)

shipping =  "#{ship_details.lastname} #{ship_details.firstname}".upcase
shipping << "\nAdresă : #{ship_details.address1}"
shipping << "\n#{ship_details.address2}" unless ship_details.address2.blank?
shipping << ", #{ship_details.city}"
shipping << "\nTelefon : #{ship_details.phone}"
shipping << "\n\n#{Spree.t(:via, scope: :print_invoice)} #{printable.shipping_methods.join(", ")}"
shipping << "\nAWB : #{printable.shipments[0].tracking}" unless printable.shipments[0].tracking.blank?

data = [[address_cell_shipping], [shipping]]

pdf.table(data, position: :left, column_widths: [pdf.bounds.width], :cell_style => {:border_width => 0.5, :border_color => "dddddd"})
