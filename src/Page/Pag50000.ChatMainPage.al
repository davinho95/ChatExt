page 50000 "Chat Main Page"
{

    Caption = 'Chat Main Menu';
    PageType = Document;
    SourceTable = "Chat User";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        
                    begin
                        CurrPage.Update(true);    
                    end;
                }
            }
            part(Favourites; "Chat Favourites")
            {
                ApplicationArea = All;
            }
            part(UserList; "Chat User List")
            {     
                ApplicationArea = All;          
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenMessageDialog)
            {
                Caption = 'Message';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = SendTo;
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var

                begin
                    CurrPage.UserList.Page.OpenDialogAndSend();
                end;
            }
            action(MyMessages)
            {
                Caption = 'My Messages';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Email;
                RunObject = page "My Messages";
            }
            action(BlockList)
            {
                Caption = 'Blocked Users';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = ErrorLog;
                RunObject = page "Chat Block List";
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
