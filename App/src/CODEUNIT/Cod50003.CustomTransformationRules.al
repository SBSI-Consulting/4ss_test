codeunit 50003 "Custom Transformation Rules"
{
    trigger OnRun()
    begin

    end;

    procedure MyProcedure(PackageName: Text)
    var
        //PageInfoFields: Record "Page Info And Fields";
        ExtensionName: text;
        NapAppExtension: Record "NAV App Installed App";
        //ExtensionPage: page "Extension Selection";
        ConfigPackTable: record "Config. Package Table";
        ConfigPakField: Record "Config. Package Field";
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Transformation Rule", 'OnTransformation', '', false, false)]
    local procedure OnTransformation(TransformationCode: Code[20]; InputText: Text; var OutputText: Text);
    begin

        case TransformationCode of
            'ACCOUNTTYPE':
                begin
                    //9 pour client
                    substringc := '9';
                    Position := STRPOS(InputText, SubStringc);
                    if Position = 1 then
                        OutputText := 'Client';
                    substringf := '0';
                    Position := STRPOS(InputText, SubStringf);
                    if Position = 1 then
                        OutputText := 'Fournisseur';
                    if Position <> 1 then OutputText := 'Compte général';
                end;
        end
    end;


    var
        Position: Integer;
        string: Text;
        stringc: Text;
        substringf: text;
        substringc: Text;

}