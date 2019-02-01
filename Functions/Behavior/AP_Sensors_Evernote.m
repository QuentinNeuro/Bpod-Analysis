function AP_Sensors_Evernote(Analysis)
% email configuration 
setpref('Internet','E_mail','kepecslab.cshl@gmail.com')
setpref('Internet','SMTP_Server','smtp.gmail.com')
setpref('Internet','SMTP_Username','kepecslab.cshl@gmail.com')
setpref('Internet','SMTP_Password','D3cision')
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

ENemail = 'egibson214.3941e4d@m.evernote.com';

% note content
text2add = strcat(' ----------------------------------------------------',...
    Analysis.Parameters.Name, [' in ' Analysis.Parameters.Rig],...
    ' ----------------------------------------------------');
noteTitle = strcat(Analysis.Parameters.Animal, ' @Sensors mice +');
tic
disp('Sending summary plot to Evernote notebook');
sendmail(ENemail, noteTitle, text2add, {SummaryPlotPath});
toc

%% Pop-up water supplement reminder
water2Supplement = 800 - Water;
msgbox({['Give ' Analysis.Parameters.Animal ' ' num2str(water2Supplement) 'uL water']}, 'Water reminder')
end
