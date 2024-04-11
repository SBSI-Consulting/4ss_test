codeunit 50006 "Automation Import Apply RS"
{
    TableNo = "Job Queue Entry";
    Permissions = tabledata "Tenant Config. Package File" = rimd, tabledata "Config. Package" = rimd;

    trigger OnRun()
    begin
        If rec."Parameter String" <> '' then
            ConfigPack.setrange(Code, rec."Parameter String");
        if ConfigPack.FindFirst() then begin
            ImportConfigPack.Run(ConfigPack);
            ApplyConfigPack.run(ConfigPack);
        end;
    end;

    Var

        ConfigPack: Record "Config. Package";
        ImportConfigPack: Codeunit "Auto. 4SS - Import RSPackage";
        ApplyConfigPack: Codeunit "Auto. 4SS - Apply RSPackage";
}