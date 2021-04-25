page 50006 "Chat Block List"
{

    Caption = 'Chat Block List';
    PageType = List;
    SourceTable = "Chat Block User";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Blocked User Name"; Rec."Blocked User Name")
                {
                    ApplicationArea = All;
                }
                field("Blocked Full Name"; Rec."Blocked Full Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit()
    var

    begin
        SetCurrUserView();
    end;

    local procedure SetCurrUserView()
    var

    begin
        Rec.FilterGroup(10);
        Rec.SetRange("User Name", UserId());
        Rec.FilterGroup(0);
    end;

}
