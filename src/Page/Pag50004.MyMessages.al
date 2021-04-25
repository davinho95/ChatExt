page 50004 "My Messages"
{

    Caption = 'My Messages';
    PageType = ListPlus;
    SourceTable = "Chat Message";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ShowFilter = false;
    SourceTableTemporary = true;
    DataCaptionExpression = '';

    layout
    {
        area(content)
        {
            field(UserName; UserName)
            {
                ApplicationArea = All;
                TableRelation = "Chat User"."User Name";

                trigger OnValidate()
                var

                begin
                    GetMessagesWithUser();
                end;
            }
            repeater(General)
            {
                ShowCaption = false;
                field("Sent at"; Rec."Sent at")
                {
                    ApplicationArea = All;
                }
                field(MessageContent; MessageReceived)
                {
                    Caption = 'Received';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(MessageSent; MessageSent)
                {
                    Caption = 'Sent';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Read by Receipient"; Rec."Read by Recipient")
                {
                    ApplicationArea = All;
                }
                field("Read at"; Rec."Read at")
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
            action(SendMessage)
            {
                Caption = 'Send Message';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = SendTo;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ChatHandler: Codeunit ChatHandler;
                begin
                    ChatHandler.OpenDialogAndSendMessage(UserName);
                    GetMessagesWithUser();
                end;
            }
        }
    }
    var
        UserName: Code[50];
        MessageReceived: Text;
        MessageSent: Text;

    trigger OnOpenPage()
    var

    begin
        GetMessagesWithUser();
    end;

    trigger OnAfterGetRecord()
    var

    begin
        LoadSentAndReceivedMessages();
    end;



    local procedure GetMessagesWithUser()
    var
        ChatMessageReceived: Record "Chat Message";
        ChatMessageSent: Record "Chat Message";
        ChatHandler: Codeunit ChatHandler;
    begin
        if UserName <> '' then begin
            Rec.DeleteAll();

            ChatMessageSent.SetCurrentKey("Sender ID", "Receiver ID");
            ChatMessageSent.SetRange("Sender ID", UserSecurityId());
            ChatMessageSent.SetRange("Receiver ID", ChatHandler.GetUserSecurityID(UserName));
            if ChatMessageSent.FindSet() then
                repeat
                    Rec.TransferFields(ChatMessageSent);
                    Rec.Insert();
                until ChatMessageSent.Next() = 0;

            if UserName <> UserId() then begin
                ChatMessageReceived.SetCurrentKey("Sender ID", "Receiver ID");
                ChatMessageReceived.SetRange("Sender ID", ChatHandler.GetUserSecurityID(UserName));
                ChatMessageReceived.SetRange("Receiver ID", UserSecurityId());
                if ChatMessageReceived.FindSet() then
                    repeat
                        Rec.TransferFields(ChatMessageReceived);
                        Rec.Insert();
                    until ChatMessageReceived.Next() = 0;
            end;

            LoadSentAndReceivedMessages();
            CurrPage.Update(false);
        end;
    end;

    local procedure LoadSentAndReceivedMessages()
    var
        ChatMessage: Record "Chat Message";
    begin
        Clear(MessageReceived);
        Clear(MessageSent);
        if ChatMessage.Get(Rec.ID) then begin
            if ChatMessage."Sender ID" = UserSecurityId() then begin
                MessageSent := ChatMessage.GetMessageContent();
            end else begin
                MessageReceived := ChatMessage.GetMessageContent();
            end;
        end;
    end;
}
