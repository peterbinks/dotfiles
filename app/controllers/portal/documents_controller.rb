module Portal
  class DocumentsController < PortalController
    def create
      @document = Document.create(document_params)

      add_term_to_document

      handle_insurance_sync

      documentable.try(:revalidate!)
      PolicyAccordion.find_step(@document.documentable, Document::DOCUMENT_STEP_LABELS[@document.label]).complete
    end

    def download
      document = Portal::Api::Document.get_document(id: params[:id])

      file = URI.parse(document.expiring_url).open
      send_file(file, filename: "#{document.label}.pdf", type: "application/pdf")
    end

    private

    attr_reader :document

    def documentable
      @document.documentable
    end

    def document_params
      params.require(:document)
        .permit(:documentable_id,
          :label,
          :documentable_type,
          :show_in_portal,
          :notify_customer,
          :uploaded_by_id,
          :saved_file)
    end

    # Currently we aren't allowing uploads for renewals, but this could change in the future.
    def add_term_to_document
      document.update(term: documentable.term)
    end

    def handle_insurance_sync
      return unless documentable.is_a? BrightPolicy
      return if documentable.in_progress_renewal_endorsement_request?

      document.send_customer_notification
      PolicyService.new(documentable).sync_insurance_history
    end
  end
end
