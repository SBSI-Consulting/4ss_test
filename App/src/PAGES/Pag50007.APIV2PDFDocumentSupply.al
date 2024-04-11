page 50007 "APIV2 - PDF Document (Supply)"
{
    APIVersion = 'v2.0';
    EntityCaption = 'PDF Document';
    EntitySetCaption = 'PDF Document';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = true;
    EntityName = 'pdfDocument2';
    EntitySetName = 'pdfDocument2';
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "Attachment Entity Buffer";
    SourceTableTemporary = true;
    APIPublisher = 'SBSIConsulting';
    APIGroup = 'Supply';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(parentId; Rec."Document Id")
                {
                    Caption = 'Parent Id';
                    Editable = false;
                }
                field(parentType; Rec."Document Type")
                {
                    Caption = 'Parent Type';
                    Editable = false;
                }
                field(pdfDocumentContent; Rec.Content)
                {
                    Caption = 'PDF Document Content';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        PDFDocumentManagement: Codeunit "PDF Document Management";
        DocumentType: Enum "Attachment Entity Buffer Document Type";
        DocumentId: Guid;
        FilterView: Text;
        DocumentIdFilter: Text;
        DocumentTypeFilter: Text;
        IdFilter: Text;
    begin
        if not PdfGenerated then begin
            FilterView := Rec.GetView();
            DocumentIdFilter := Rec.GetFilter("Document Id");
            DocumentTypeFilter := Rec.GetFilter("Document Type");
            IdFilter := Rec.GetFilter(Id);
            if (DocumentIdFilter <> '') and (IdFilter <> '') and (LowerCase(DocumentIdFilter) <> LowerCase(IdFilter)) then
                Error(ConflictingIdsErr, DocumentIdFilter, IdFilter);
            if (DocumentTypeFilter = '') then
                Error(MissingParentTypeErr);
            if (DocumentIdFilter = '') then
                if (IdFilter = '') then
                    Error(MissingParentIdErr)
                else
                    DocumentIdFilter := IdFilter
            else
                IdFilter := DocumentIdFilter;

            DocumentId := Format(DocumentIdFilter);
            DocumentType := ConvertDocumentTypeFilterToEnum(DocumentTypeFilter);
            Rec.SetView(FilterView);
            if IsNullGuid(DocumentId) then
                exit(false);
            //PdfGenerated := PDFDocumentManagement.GeneratePdfWithDocumentType(DocumentId, DocumentType, Rec);
        end;
        exit(true);
    end;

    var
        GraphMgtAttachmentBuffer: Codeunit "Graph Mgt - Attachment Buffer";
        PdfGenerated: Boolean;
        ConflictingIdsErr: Label 'You have specified conflicting identifiers: %1 and %2.', Comment = '%1 - a GUID, %2 - a GUID';
        MissingParentIdErr: Label 'You must specify a parentId in the request body.', Comment = 'parentId is a field name and should not be translated.';
        MissingParentTypeErr: Label 'You must specify a parentType in the request body.', Comment = 'parentType is a field name and should not be translated.';
        DocumentTypeInvalidErr: Label 'Document type is not valid.';

    local procedure ConvertDocumentTypeFilterToEnum(DocumentTypeFilter: Text): Enum "Attachment Entity Buffer Document Type"
    var
        AttachmentEntityBufferDocType: Enum "Attachment Entity Buffer Document Type";
    begin
        case DocumentTypeFilter of
            'Journal':
                exit(AttachmentEntityBufferDocType::Journal);
            'Sales Invoice':
                exit(AttachmentEntityBufferDocType::"Sales Invoice");
            'Sales Quote':
                exit(AttachmentEntityBufferDocType::"Sales Quote");
            'Sales Order':
                exit(AttachmentEntityBufferDocType::"Sales Order");
            'Sales Credit Memo':
                exit(AttachmentEntityBufferDocType::"Sales Credit Memo");
            'Purchase Invoice':
                exit(AttachmentEntityBufferDocType::"Purchase Invoice");
            ' ':
                exit(AttachmentEntityBufferDocType::" ");
        end;
        Error(DocumentTypeInvalidErr);
    end;
}