codeunit 50004 "Update Posted Entries"
{

    Permissions = tabledata "sales invoice header" = rimd, tabledata "sales invoice line" = rimd, tabledata "Sales Quote Entity Buffer" = rimd, tabledata "Sales Invoice Entity Aggregate" = rimd;
    trigger OnRun()
    begin
        ImportExcel();

    end;

    procedure UpdateSalesInvoices()
    var
        SalesInvoiceHeader: record "Sales Invoice Header";
    begin

    end;

    procedure UpdateSalesInvoiceslines()
    var
        SalesInvoiceLine: record "Sales Invoice Line";
    begin

    end;

    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        InStr: InStream;
        Filename: Text;
    begin
        if UploadIntoStream('Select your file', '', '', Filename, InStr) then;
    end;

    procedure ImportExcel()
    var
        ImportExcelOption: Label 'SalesInvoices,SalesInvoicesLines,SalesQuoteBuffer,SalesInvoiceAggregate';
        Selection: integer;
    begin

        Selection := strmenu(ImportExcelOption, 1);

        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := Rec_ExcelBuffer.SelectSheetsNameStream(Instr)
        else
            exit;


        Rec_ExcelBuffer.Reset;
        Rec_ExcelBuffer.OpenBookStream(Instr, Sheetname);
        Rec_ExcelBuffer.ReadSheet();

        Commit();
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;
        //Message(Format(Rows));

        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;
        //Message(Format(Columns));
        //Modify or Insert
        for RowNo := 2 to Rows do begin
            case selection of
                1:
                    begin
                        SalesInvoices.reset;
                        If SalesInvoices.get(GetValueAtIndex(RowNo, 1)) then begin
                            Evaluate(SalesInvoices."4SS Offer No.", GetValueAtIndex(RowNo, 2));
                            SalesInvoices."4SS Offer No." := GetValueAtIndex(RowNo, 2);
                            Evaluate(SalesInvoices."4SS Sell to Country Name", GetValueAtIndex(RowNo, 3));
                            SalesInvoices."4SS Sell to Country Name" := GetValueAtIndex(RowNo, 3);
                            Evaluate(SalesInvoices."4SS Bill to Country Name", GetValueAtIndex(RowNo, 4));
                            SalesInvoices."4SS bill to Country Name" := GetValueAtIndex(RowNo, 4);
                            Evaluate(SalesInvoices."4SS ship to Country Name", GetValueAtIndex(RowNo, 5));
                            SalesInvoices."4SS ship to Country Name" := GetValueAtIndex(RowNo, 5);
                            Evaluate(SalesInvoices."4SS ship to Country Name", GetValueAtIndex(RowNo, 6));
                            SalesInvoices."4SS Estimation" := TransformTextToBoolean(GetValueAtIndex(RowNo, 6));
                            Evaluate(SalesInvoices."4SS Tracking No.", GetValueAtIndex(RowNo, 7));
                            SalesInvoices."4SS Tracking No." := GetValueAtIndex(RowNo, 7);
                            Evaluate(SalesInvoices."4SS Shipment No.", GetValueAtIndex(RowNo, 8));
                            SalesInvoices."4SS Shipment No." := GetValueAtIndex(RowNo, 8);
                            SalesInvoices.modify(true);
                        end
                    end;
                2:
                    begin
                        SalesInvoiceLine.reset;
                        If SalesInvoiceLine.get(GetValueAtIndex(RowNo, 1), GetValueAtIndex(RowNo, 2)) then begin

                            Evaluate(SalesInvoiceLine."4SS Package Quantity", GetValueAtIndex(RowNo, 3));


                            SalesInvoiceLine.modify(true);
                        end

                    end;
                3:
                    begin
                        SalesQuoteEntityBuffer.reset;
                        If SalesQuoteEntityBuffer.get(GetValueAtIndex(RowNo, 1)) then begin
                            Evaluate(SalesQuoteEntityBuffer."4SS Offer No.", GetValueAtIndex(RowNo, 2));
                            SalesQuoteEntityBuffer."4SS Offer No." := GetValueAtIndex(RowNo, 2);
                            Evaluate(SalesQuoteEntityBuffer."4SS Sell to Country Name", GetValueAtIndex(RowNo, 3));
                            SalesQuoteEntityBuffer."4SS Sell to Country Name" := GetValueAtIndex(RowNo, 3);
                            Evaluate(SalesQuoteEntityBuffer."4SS Bill to Country Name", GetValueAtIndex(RowNo, 4));
                            SalesQuoteEntityBuffer."4SS bill to Country Name" := GetValueAtIndex(RowNo, 4);
                            Evaluate(SalesQuoteEntityBuffer."4SS ship to Country Name", GetValueAtIndex(RowNo, 5));
                            SalesQuoteEntityBuffer."4SS ship to Country Name" := GetValueAtIndex(RowNo, 5);
                            Evaluate(SalesQuoteEntityBuffer."4SS ship to Country Name", GetValueAtIndex(RowNo, 6));
                            SalesQuoteEntityBuffer."4SS Estimation" := TransformTextToBoolean(GetValueAtIndex(RowNo, 6));
                            Evaluate(SalesQuoteEntityBuffer."4SS Location Code (API)", GetValueAtIndex(RowNo, 7));
                            SalesQuoteEntityBuffer."4SS Location Code (API)" := GetValueAtIndex(RowNo, 7);
                            Evaluate(SalesQuoteEntityBuffer."4SS Shipping Agent Code (API)", GetValueAtIndex(RowNo, 8));
                            SalesQuoteEntityBuffer."4SS Shipping Agent Code (API)" := GetValueAtIndex(RowNo, 8);
                            //Evaluate(SalesQuoteEntityBuffer."4SS Ship. Agent Serv. Code (API)", GetValueAtIndex(RowNo, 9));
                            //SalesQuoteEntityBuffer."4SS Ship. Agent Serv. Code (API)" := GetValueAtIndex(RowNo, 9);
                            SalesQuoteEntityBuffer.modify(true);
                        end
                    end;
                4:
                    begin
                        SalesInvoiceEntityBufferAggregate.reset;
                        If SalesInvoiceEntityBufferAggregate.get(GetValueAtIndex(RowNo, 1), TransformTextToBoolean(GetValueAtIndex(RowNo, 2))) then begin
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS Offer No.", GetValueAtIndex(RowNo, 3));
                            SalesInvoiceEntityBufferAggregate."4SS Offer No." := GetValueAtIndex(RowNo, 3);
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS Sell to Country Name", GetValueAtIndex(RowNo, 4));
                            SalesInvoiceEntityBufferAggregate."4SS Sell to Country Name" := GetValueAtIndex(RowNo, 4);
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS Bill to Country Name", GetValueAtIndex(RowNo, 5));
                            SalesInvoiceEntityBufferAggregate."4SS bill to Country Name" := GetValueAtIndex(RowNo, 5);
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS ship to Country Name", GetValueAtIndex(RowNo, 6));
                            SalesInvoiceEntityBufferAggregate."4SS ship to Country Name" := GetValueAtIndex(RowNo, 6);
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS ship to Country Name", GetValueAtIndex(RowNo, 7));
                            SalesInvoiceEntityBufferAggregate."4SS Estimation" := TransformTextToBoolean(GetValueAtIndex(RowNo, 7));
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS Tracking No.", GetValueAtIndex(RowNo, 8));
                            SalesInvoiceEntityBufferAggregate."4SS Tracking No." := GetValueAtIndex(RowNo, 8);
                            Evaluate(SalesInvoiceEntityBufferAggregate."4SS Location Code", GetValueAtIndex(RowNo, 9));
                            SalesInvoiceEntityBufferAggregate."4SS Location Code" := GetValueAtIndex(RowNo, 9);
                            SalesInvoiceEntityBufferAggregate.modify(true);
                        end
                    end;

            end;
            /* SalesInvoices.reset;
            If SalesInvoices.get(GetValueAtIndex(RowNo, 1)) then begin
                Evaluate(SalesInvoices."4SS Offer No.", GetValueAtIndex(RowNo, 2));
                SalesInvoices."4SS Offer No." := GetValueAtIndex(RowNo, 2);
                Evaluate(SalesInvoices."4SS Sell to Country Name", GetValueAtIndex(RowNo, 3));
                SalesInvoices."4SS Sell to Country Name" := GetValueAtIndex(RowNo, 3);
                Evaluate(SalesInvoices."4SS Bill to Country Name", GetValueAtIndex(RowNo, 4));
                SalesInvoices."4SS bill to Country Name" := GetValueAtIndex(RowNo, 4);
                Evaluate(SalesInvoices."4SS ship to Country Name", GetValueAtIndex(RowNo, 5));
                SalesInvoices."4SS ship to Country Name" := GetValueAtIndex(RowNo, 5);
                Evaluate(SalesInvoices."4SS ship to Country Name", GetValueAtIndex(RowNo, 6));
                SalesInvoices."4SS Estimation" := TransformTextToBoolean(GetValueAtIndex(RowNo, 6));
                Evaluate(SalesInvoices."4SS Tracking No.", GetValueAtIndex(RowNo, 7));
                SalesInvoices."4SS Tracking No." := GetValueAtIndex(RowNo, 7);
                Evaluate(SalesInvoices."4SS Shipment No.", GetValueAtIndex(RowNo, 8));
                SalesInvoices."4SS Shipment No." := GetValueAtIndex(RowNo, 8);
                SalesInvoices.modify(true);
            end */
            /*  Rec_GenJnl.Reset();
            
             if Rec_GenJnl.Get(GetValueAtIndex(RowNo, 1), GetValueAtIndex(RowNo, 2), GetValueAtIndex(RowNo, 3)) then begin
                 Evaluate(Rec_GenJnl."Posting Date", GetValueAtIndex(RowNo, 4));
                 Rec_GenJnl.Validate("Posting Date");
                 Evaluate(Rec_GenJnl."Document No.", GetValueAtIndex(RowNo, 5));
                 Rec_GenJnl.Validate("Document No.");
                 Evaluate(Rec_GenJnl."Account Type", GetValueAtIndex(RowNo, 6));
                 Rec_GenJnl.Validate("Account Type");
                 Evaluate(Rec_GenJnl."Account No.", GetValueAtIndex(RowNo, 7));
                 Rec_GenJnl.Validate("Account No.");
                 Evaluate(Rec_GenJnl."Shortcut Dimension 1 Code", GetValueAtIndex(RowNo, 8));
                 Rec_GenJnl.Validate("Shortcut Dimension 1 Code");
                 //, GetValueAtIndex(RowNo, 9));
                 //Rec_GenJnl.Validate(LeaseNo);
                 Evaluate(Rec_GenJnl.Description, GetValueAtIndex(RowNo, 10));
                 Rec_GenJnl.Validate(Description);
                 Evaluate(Rec_GenJnl.Amount, GetValueAtIndex(RowNo, 11));
                 Rec_GenJnl.Validate(Amount);
                 Evaluate(Rec_GenJnl."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 12));
                 Rec_GenJnl.Validate(Rec_GenJnl."Shortcut Dimension 2 Code");
                 Rec_GenJnl.Modify(true);

             end
             else begin
                 Rec_GenJnl.Init();
                 Evaluate(Rec_GenJnl."Journal Template Name", GetValueAtIndex(RowNo, 1));

                 Evaluate(Rec_GenJnl."Journal Batch Name", GetValueAtIndex(RowNo, 2));
                 Evaluate(Rec_GenJnl."Line No.", GetValueAtIndex(RowNo, 3));
                 Evaluate(Rec_GenJnl."Posting Date", GetValueAtIndex(RowNo, 4));
                 Evaluate(Rec_GenJnl."Document No.", GetValueAtIndex(RowNo, 5));
                 Evaluate(Rec_GenJnl."Account Type", GetValueAtIndex(RowNo, 6));
                 Evaluate(Rec_GenJnl."Account No.", GetValueAtIndex(RowNo, 7));
                 Rec_GenJnl.Validate("Account No.");
                 Evaluate(Rec_GenJnl."Shortcut Dimension 1 Code", GetValueAtIndex(RowNo, 8));
                 //Evaluate(Rec_GenJnl.LeaseNo, GetValueAtIndex(RowNo, 9));
                 Evaluate(Rec_GenJnl.Description, GetValueAtIndex(RowNo, 10));
                 Evaluate(Rec_GenJnl.Amount, GetValueAtIndex(RowNo, 11));
                 Evaluate(Rec_GenJnl."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 12));
                 Rec_GenJnl.Validate(Amount);
                 Rec_GenJnl.Validate("Posting Date");
                 Rec_GenJnl.Validate("Document No.");
                 //Rec_GenJnl.Validate(LeaseNo);
                 Rec_GenJnl.Validate("Shortcut Dimension 1 Code");
                 Rec_GenJnl.Validate("Shortcut Dimension 2 Code");
                 Rec_GenJnl.Insert();
             end;
  */
        end;
        Message('%1 Rows Imported Successfully!!', Rows - 1);


    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
    begin
        Rec_ExcelBuffer.Reset();
        IF Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");
    end;

    procedure TransformTextToBoolean(CellValue: text): boolean;
    begin
        if CellValue = 'false' then
            exit(false)
        else
            exit(true);
    end;

    procedure ExportGenJnlBuffer()
    var
        myInt: Integer;
    begin
        ExportHeaderGenJnl();
        Rec_GenJnl.SetRange("Journal Template Name", 'GENERAL');
        if Rec_GenJnl.FindFirst() then begin
            repeat
                Rec_ExcelBuffer.NewRow();
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Journal Template Name"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Journal Batch Name"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Rec_GenJnl."Line No.", false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Number);
                Rec_ExcelBuffer.AddColumn(Rec_GenJnl."Posting Date", false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Date);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Document No."), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Account Type"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Account No."), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Shortcut Dimension 1 Code"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                //Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl.LeaseNo), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl.Description), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Rec_GenJnl.Amount, false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Number);
                Rec_ExcelBuffer.AddColumn(Format(Rec_GenJnl."Shortcut Dimension 2 Code"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn('', false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn('', false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);

            until Rec_GenJnl.next = 0;
            Rec_ExcelBuffer.CreateNewBook('General Journal');
            Rec_ExcelBuffer.WriteSheet('General Journal', CompanyName(), UserId());
            Rec_ExcelBuffer.CloseBook();
            Rec_ExcelBuffer.OpenExcel();


        end;
    end;

    local procedure ExportHeaderGenJnl()
    begin
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.DeleteAll();
        Rec_ExcelBuffer.Init();
        Rec_ExcelBuffer.AddColumn('Journal Template', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Batch Name', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Line No.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Document No.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Account Type', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Account No.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Dept Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Lease No.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Description', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Credit Grade Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Customer Type Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('SBU Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);

    end;

    var
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        Filename: Text;
        FileMgmt: Codeunit "File Management";
        ExcelFile: File;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        RowNo: Integer;
        ColNo: Integer;
        Rec_GenJnl: Record "Gen. Journal Line";
        SalesInvoices: Record "sales invoice header";
        SalesInvoiceLine: Record "sales invoice line";
        SalesQuoteEntityBuffer: record "Sales Quote Entity Buffer";
        SalesInvoiceEntityBufferAggregate: Record "Sales Invoice Entity Aggregate";
}
