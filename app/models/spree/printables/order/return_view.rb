module Spree
  class Printables::Order::ReturnView < Printables::Invoice::BaseView
    def_delegators :@printable,
                   :email,
                   :bill_address,
                   :ship_address,
                   :tax_address,
                   :item_total,
                   :total,
                   :reimbursed_amount,
                   :payments,
                   :shipments

    money_methods :reimbursed_amount

    def items
      order_items + order_return_items.uniq(&:sku)
    end

    def order_items
      printable.line_items.map do |item|
        Spree::Printables::Invoice::Item.new(
          sku: item.variant.sku,
          name: item.variant.name,
          options_text: item.variant.options_text,
          price: item.price,
          quantity: item.quantity,
          total: item.total
        )
      end
    end

    def order_return_items
      inventory_units = printable.reimbursements.reimbursed.flat_map(&:inventory_units).group_by(&:line_item_id)
      printable.reimbursements.reimbursed.flat_map(&:return_items).map do |item|
        quantity = inventory_units[item.inventory_unit.line_item_id].count
        Spree::Printables::Invoice::Item.new(
          sku: item.inventory_unit.variant.sku,
          name: item.inventory_unit.variant.name,
          options_text: item.inventory_unit.variant.options_text,
          price: -item.total,
          quantity: -quantity,
          total: -(quantity * item.total)
        )
      end
    end

    def firstname
      printable.tax_address.firstname
    end

    def lastname
      printable.tax_address.lastname
    end

    def reimbursed_amount
      -printable.reimbursed_amount
    end

    def total
      printable.total - printable.reimbursed_amount
    end

    private

    def all_adjustments
      printable.all_adjustments.eligible
    end
  end
end
