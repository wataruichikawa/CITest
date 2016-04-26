public with sharing class OutboundEmail {

    /** メッセージリスト */
    private List<Messaging.SingleEmailMessage> messages;

    /**
     * コンストラクタ
     */
    public OutboundEmail() {
        messages = new List<Messaging.SingleEmailMessage>();
    }

    /**
     * メッセージ作成
     * @param replyTo 返信先アドレス
     * @param senderDisplayName 差出人名
     * @param toAddresses To アドレス
     * @param ccAddresses Cc アドレス
     * @param subject 件名
     * @param planText 本文
     */
    public void createSendMessage(
            String replyTo
            , String senderDisplayName
            , String[] toAddresses
            , String[] ccAddresses
            , String subject
            , String planText) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(replyTo != null) {
            message.setReplyTo(replyTo);
        }
        if(senderDisplayName != null) {
            message.setSenderDisplayName(senderDisplayName);
        }
        message.setToAddresses(toAddresses);
        if(ccAddresses != null) {
            message.setCcAddresses(ccAddresses);
        }
        message.setSubject(subject);
        message.setPlainTextBody(planText);
        message.setCharset('ISO-2022-JP');
        message.setUseSignature(false);
        addMessage(message);
    }

    /**
     * メッセージ追加
     * @param message メッセージ
     */
    private void addMessage(Messaging.SingleEmailMessage message) {
        if(messages == null) {
            messages = new List<Messaging.SingleEmailMessage>();
        }
        messages.add(message);
    }

    /**
     * メール送信
     */
    public void send() {
        if(messages != null && messages.size() > 0) {
            if (!Test.isRunningTest()) Messaging.sendEmail(messages);
        }
    }

    /*
     * ファイル添付メソッド
     * @param List<Attachment> attachFiles
     */
    public void attachFilesToOneMessage(List<Attachment> attachFiles){
        if(messages != null && messages.size() > 0) {
            Messaging.SingleEmailMessage message = messages.get(0);
            List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
            for (Attachment at : attachFiles){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(at.name);
                efa.setBody(at.body);
                efaList.add(efa);
            }
            message.setFileAttachments(efaList);
        }
    }
}