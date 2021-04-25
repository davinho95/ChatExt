page 50003 "Message Dialog"
{
    
    Caption = 'Write a message...';
    PageType = StandardDialog;
    
    layout
    {
        area(content)
        {
            field(MessageContent;MessageContent)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;
            }
            field(SendEmail; SendEmail)
            {
                Caption = 'Send Email';
                ApplicationArea = All;
            }
        }
    }
    var
        MessageContent: Text;
        SendEmail: Boolean;

    procedure GetMessageContent(): Text
    var
        
    begin
        exit(MessageContent);    
    end;

    procedure GetSendEmail(): Boolean
    var
        
    begin
        exit(SendEmail);    
    end;   
}