page 50002 "Chat User List"
{

    Caption = 'Chat User List';
    PageType = ListPart;
    SourceTable = "Chat User";
    SourceTableView = where(Available = const(true));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenMessageDialogAndSend)
            {
                Caption = 'Send Message';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = SendTo;
                ApplicationArea = All;

                trigger OnAction()
                var

                begin
                    OpenDialogAndSend();
                end;
            }
            action(AddToFavourites)
            {
                Caption = 'Add to favourites';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ChatHandler: Codeunit ChatHandler;
                begin
                    ChatHandler.AddToFavourites(Rec."User Name");   
                end;
            }
        }
    }

    var
        MessageContent: Text;

    trigger OnInit()
    var

    begin
        //SetCurrUserView();
    end;

    local procedure SetCurrUserView()
    var

    begin
        Rec.FilterGroup(10);
        Rec.SetFilter("User Name", '<>%1', UserId());
        rec.FilterGroup(0);
    end;

    procedure OpenDialogAndSend()
    var
        ChatHandler: Codeunit ChatHandler;
        ChatUser: Record "Chat User";
    begin
        CurrPage.SetSelectionFilter(ChatUser);
        ChatHandler.OpenDialogAndSendMessage(ChatUser);
    end;
}
