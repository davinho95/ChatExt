page 50005 "Chat Favourites"
{

    Caption = 'Chat Favourites';
    PageType = ListPart;
    SourceTable = "Chat Favourites";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Favourite Full Name"; Rec."Favourite Full Name")
                {
                    ApplicationArea = All;
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
            action(RemoveFavourite)
            {
                Caption = 'Remove from favourites';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ChatHandler: Codeunit ChatHandler;
                begin
                    ChatHandler.RemoveFromFavourites(Rec."Favourite User Name");
                end;
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

    local procedure OpenDialogAndSend()
    var
        ChatHandler: Codeunit ChatHandler;
        ChatUser: Record "Chat User";
        ChatFavourites: Record "Chat Favourites";
    begin
        CurrPage.SetSelectionFilter(ChatFavourites);
        if ChatFavourites.FindSet() then
            repeat
                if ChatUser.Get(ChatFavourites."Favourite User Name") then
                    ChatUser.Mark(true);
            until ChatFavourites.Next() = 0;

        ChatUser.MarkedOnly(true);
        ChatHandler.OpenDialogAndSendMessage(ChatUser);
    end;

}
