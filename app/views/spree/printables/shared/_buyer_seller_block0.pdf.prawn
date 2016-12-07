buyer_details = printable.bill_address

pdf.move_down 2

buyer_seller_table_width = [0.15, 0.35].map { |w| w * pdf.bounds.width }

buyer_address =  "#{buyer_details.address1}"
buyer_address << "\n#{buyer_details.address2}" unless buyer_details.address2.blank?
buyer_address << ", #{buyer_details.city}"

buyer_info = pdf.make_table([
  [Spree.t(:buyer, scope: :print_invoice) + " : ", "#{buyer_details.lastname} #{buyer_details.firstname}".upcase],
  ["Adresă : ", buyer_address],
  ["Telefon : ", buyer_details.phone]
], column_widths: buyer_seller_table_width, :cell_style => {:border_width => 0, :padding => 1.5})

seller_info = pdf.make_table([
  [Spree.t(:seller, scope: :print_invoice) + " : ", "MICUL MARE GIGANT SRL"],
  ["C.I.F. : ", "36435340"],
  ["Nr ord reg com : ", "J40/10967/2016"],
  ["Sediul : ", "Bd Decebal Nr 12, Bl S7, Sc 1, Et 5, Ap 15, Camera 1, Sector 3, Bucuresti"],
  ["Punct de lucru : ", "Bd Energeticenilor Nr 9E, Bl M1, Camera 1222, Sector 3, Bucuresti"],
  ["Capital social : ", "200"],
  ["Bancă : ", "ING - Suc Oltenitei"],
  ["Cont : ", "RO80INGB0000999906201554"],
], column_widths: buyer_seller_table_width, :cell_style => {:border_width => 0, :padding => 1.5})

pdf.table(
  [[buyer_info, seller_info]], column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2],
  :cell_style => {:border_width => 0.5, :padding => 4, :border_color => "dddddd"}
)
