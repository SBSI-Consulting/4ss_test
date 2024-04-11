pageextension 50010 "GeneralLedgerSetupExt" extends "General Ledger Setup"
{
    layout
    {
        modify("Payroll Trans. Import Format")
        {
            Visible = true;
            trigger OnBeforeValidate()
            begin

            end;
        }
    }

    actions
    {
    }
}