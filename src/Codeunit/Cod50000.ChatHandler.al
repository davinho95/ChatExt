codeunit 50000 ChatHandler
{
    trigger OnRun()
    var

    begin

    end;

    procedure OpenDialogAndSendMessage(ChatUserName: Code[50])
    var
        ChatUser: Record "Chat User";
    begin
        ChatUser.SetRange("User Name", ChatUserName);
        OpenDialogAndSendMessage(ChatUser);
    end;

    procedure OpenDialogAndSendMessage(var ChatUser: Record "Chat User")
    var
        MessageDialog: Page "Message Dialog";
        MessageContent: Text;
        SendEmail: Boolean;
        EmptyMessageLbl: Label 'Empty message cannot be sent.';
    begin
        CheckUserMessageLimit();
        if MessageDialog.RunModal() = Action::OK then begin
            MessageContent := MessageDialog.GetMessageContent();
            if MessageContent = '' then
                Error(EmptyMessageLbl);

            SendEmail := MessageDialog.GetSendEmail();

            SendMessage(ChatUser, MessageContent);
            if SendEmail then
                SendEmailToRecipient(ChatUser."User Name", MessageContent);
        end;
    end;

    procedure GetUserSecurityID(UserName: Code[50]): Guid
    var
        User: Record User;
    begin
        User.SetRange("User Name", UserName);
        if User.FindFirst() then
            exit(User."User Security ID");

    end;

    procedure AddToFavourites(FavouriteUserName: Code[50])
    var
        ChatFavourites: Record "Chat Favourites";
    begin
        if not ChatFavourites.Get(UserId, FavouriteUserName) then begin
            Clear(ChatFavourites);
            ChatFavourites."Favourite User Name" := FavouriteUserName;
            ChatFavourites.Insert(true);
        end;
    end;

    procedure RemoveFromFavourites(FavouriteUserName: Code[50])
    var
        ChatFavourites: Record "Chat Favourites";
    begin
        if ChatFavourites.Get(UserId, FavouriteUserName) then
            ChatFavourites.Delete();
    end;

    local procedure SendMessage(var ChatUser: Record "Chat User"; MessageContent: Text)
    var
        ChatMessage: Record "Chat Message";
    begin
        if ChatUser.FindSet() then
            repeat
                CheckSenderIsBlocked(ChatUser."User Name");

                Clear(ChatMessage);
                ChatMessage.SetMessageContent(MessageContent);
                ChatMessage."Receiver ID" := GetUserSecurityID(ChatUser."User Name");
                ChatMessage.Insert(true);
            until ChatUser.Next() = 0;
    end;

    local procedure SendEmailToRecipient(ReceiverUserName: Code[50]; MessageContent: Text)
    var
        SMTPMail: Codeunit "SMTP Mail";
        ReceiverUserSetup: Record "User Setup";
        SenderUserSetup: Record "User Setup";
        ReceiverChatUser: Record "Chat User";
        SenderChatUser: Record "Chat User";
        SubjectLbl: Label 'You have received a new message from %1';
        Recipients: List of [Text];
    begin
        if SMTPMail.IsEnabled() then begin
            SenderUserSetup.Get(UserId());
            SenderChatUser.Get(UserId);
            ReceiverUserSetup.Get(ReceiverUserName);
            ReceiverChatUser.Get(ReceiverUserName);

            SenderChatUser.CalcFields("Full Name");
            ReceiverChatUser.CalcFields("Full Name");

            SMTPMail.Initialize();
            SMTPMail.AddFrom(SenderChatUser."Full Name", SenderUserSetup."E-Mail");
            SMTPMail.AddSubject(StrSubstNo(SubjectLbl, SenderChatUser."Full Name"));
            SMTPMail.AddTextBody(MessageContent);

            Recipients.Add(ReceiverUserSetup."E-Mail");
            SMTPMail.AddRecipients(Recipients);

            SMTPMail.SendShowError();
        end;
    end;

    local procedure CheckSenderIsBlocked(RecipientUserName: Code[50])
    var
        ChatBlockUser: Record "Chat Block User";
        SendingMessageIsBlockedLbl: Label 'Sending messages to %1 user has been blocked.';
    begin
        if ChatBlockUser.Get(RecipientUserName, UserId) then begin
            ChatBlockUser.CalcFields("Full Name");
            Error(StrSubstNo(SendingMessageIsBlockedLbl, ChatBlockUser."Full Name"));
        end;

    end;

    local procedure CheckUserMessageLimit()
    var
        ChatMessage: Record "Chat Message";
        MessageLimitReachedLbl: Label 'You have reached the maximum daily message count.';
    begin
        ChatMessage.SetCurrentKey("Sender ID", "Sent at");
        ChatMessage.SetRange("Sender ID", UserSecurityId());
        ChatMessage.SetRange("Sent at", CreateDateTime(Today, 0T), CreateDateTime(Today, 235959T));
        if ChatMessage.Count = GetDailyMessageLimitPerUser() then
            Error(MessageLimitReachedLbl);
    end;

    local procedure GetDailyMessageLimitPerUser(): Integer
    var

    begin
        exit(5);
    end;
}
