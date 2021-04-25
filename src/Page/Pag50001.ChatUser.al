page 50001 "Chat User"
{
    
    ApplicationArea = All;
    Caption = 'Chat User';
    PageType = List;
    SourceTable = "Chat User";
    UsageCategory = Lists;
    DeleteAllowed = false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
