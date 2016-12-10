class AddIndexOnSpreeBookkeepingDocuments < ActiveRecord::Migration
  def change
    add_index :spree_bookkeeping_documents, [:printable_id, :printable_type], name: 'invoice_index_on_printable'
    add_index :spree_bookkeeping_documents, :template
  end
end
