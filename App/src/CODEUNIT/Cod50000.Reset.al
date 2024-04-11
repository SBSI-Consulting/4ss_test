codeunit 50000 "Reset"
{
    trigger OnRun();
    var
        ConfigTableProcessingRule: record "Config. Table Processing Rule";
    begin
        case ConfigTableProcessingRule."Table ID" of
            309:
                ClearSelectedFields(ConfigTableProcessingRule."Table ID", 6, 8, 0);
        end;
    end;

    local procedure ClearSelectedFields(TableNo: Integer; F1: Integer; F2: Integer; F3: Integer)
    var
        i: Integer;
        FieldArray: array[3] of Integer;
        DeleteConfirm: Text;
    begin
        FieldArray[1] := F1;
        FieldArray[2] := F2;
        FieldArray[3] := F3;
        DeleteConfirm := 'Do you want to delete the following record? \';
        Clear(RecRef);
        Clear(FldRef);
        Clear(KeyRefer);
        RecRef.Open(TableNo);
        RecRef.SetRecFilter();
        KeyRefer := RecRef.KeyIndex(1);
        IF RecRef.FindSet() then begin
            repeat
                for i := 1 TO RecRef.FieldCount do begin
                    FldRef := RecRef.FieldIndex(FieldArray[i]);
                    IF FieldArray[i] <> 0 then begin
                        case FldRef.Type of
                            FldRef.Type::Text:
                                FldRef.Value := '';
                            FldRef.Type::Integer:
                                fldref.value := 0;
                        end;
                    end;
                end;
            until RecRef.Next() = 0;
        end;
        IF RecRef.FindSet() then begin
            DeleteConfirm := DeleteConfirm + Format(RecRef);
            repeat
                IF RecRef.Count = 1 then begin
                    IF Confirm(DeleteConfirm) then begin
                        RecRef.Delete();
                        Message('Record is deleted!')
                    end;
                end
                else begin
                    IF Confirm('Do you want to bulk delete all the records?') then begin
                        RecRef.DeleteAll();
                        Message('Records are deleted!');
                    end;
                end;

            until RecRef.Next() = 0;
        end;
        RecRef.Close();
    end;

    local procedure FetchRecord(TableNo: Integer; Pk1: Text; Pk2: Text; Pk3: Text);
    var
        i: Integer;
        PK: array[3] of Text;
        DeleteConfirm: Text;
    begin
        PK[1] := Pk1;
        PK[2] := Pk2;
        PK[3] := Pk3;
        DeleteConfirm := 'Do you want to delete the following record? \';
        Clear(RecRef);
        Clear(FldRef);
        Clear(KeyRefer);
        RecRef.Open(TableNo);
        RecRef.SetRecFilter();
        KeyRefer := RecRef.KeyIndex(1);
        for i := 1 TO KeyRefer.FieldCount() do begin
            FldRef := KeyRefer.FieldIndex(i);
            IF PK[i] <> '' then
                FldRef.SetFilter(PK[i]);
        end;
        IF RecRef.FindSet() then begin
            DeleteConfirm := DeleteConfirm + Format(RecRef);
            repeat
                IF RecRef.Count = 1 then begin
                    IF Confirm(DeleteConfirm) then begin
                        RecRef.Delete();
                        Message('Record is deleted!')
                    end;
                end
                else begin
                    IF Confirm('Do you want to bulk delete all the records?') then begin
                        RecRef.DeleteAll();
                        Message('Records are deleted!');
                    end;
                end;

            until RecRef.Next() = 0;
        end;
        RecRef.Close();
    end;

    var

        TableNo: Integer;
        TableName: Text;
        PrimaryKeyFilter1: Text;
        PrimaryKeyFilter2: Text;
        PrimaryKeyFilter3: Text;
        RecRef: RecordRef;
        FldRef: FieldRef;
        KeyRefer: KeyRef;
        KeyIndex: Integer;
}