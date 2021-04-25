table 50001 "Chat Message"
{
    Caption = 'Chat Message';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Sender ID"; Guid)
        {
            Caption = 'Sender ID';
            DataClassification = EndUserPseudonymousIdentifiers;
            Editable = false;
            ExtendedDatatype = Masked;
        }
        field(3; "Receiver ID"; Guid)
        {
            Caption = 'Receiver ID';
            DataClassification = EndUserPseudonymousIdentifiers;
            Editable = false;
            ExtendedDatatype = Masked;
        }
        field(4; "Sent at"; DateTime)
        {
            Caption = 'Sent at';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Read by Recipient"; Boolean)
        {
            Caption = 'Read by Recipient';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var

            begin
                HandleReadBy();
            end;
        }
        field(6; "Read at"; DateTime)
        {
            Caption = 'Read at';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Message Content"; Blob)
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        Key(Users; "Sender ID", "Receiver ID")
        {
            Enabled = true;
        }
        Key(Sender; "Sender ID", "Sent at")
        {
            Enabled = true;
        }
    }
    trigger OnInsert()
    var

    begin
        Validate("Sender ID", UserSecurityId());
        Validate("Sent at", CurrentDateTime());
    end;

    local procedure HandleReadBy()
    var
        
    begin
        if "Receiver ID" = UserSecurityId() then begin
            if "Read by Recipient" then
                Validate("Read at", CurrentDateTime())
            else
                Validate("Read at", 0DT);
        end else begin
            Rec."Read by Recipient" := xRec."Read by Recipient";
        end;
    end;

    procedure SetMessageContent(NewMessageContent: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Message Content");
        "Message Content".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewMessageContent);
    end;

    procedure GetMessageContent(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Message Content");
        "Message Content".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

}
