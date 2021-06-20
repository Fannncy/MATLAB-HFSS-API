% Ŀ�꣺���ڽ���Ƶ��ѡ��������Ľű�
% 2020.9.7�� by Vega Lau

clear, clc

units = 'mm';
units2 = 'deg';

% ������Ʊ���
p = 12.7; % ��Ԫ�߳�
h = 5; % ������߶�
hh = 2; % ������ʲ�߶�
l = 2.91; % Y�������ĳ���
w = 3.26; % Y�������Ŀ��
ll = 8.6; % +�������ĳ���
ww = 2.4; % +�������Ŀ��
t = 0; % ��Ų�����Ƕ�

% �ļ������洢·��
fileName = 'matlabhfss';
tmpScriptFile = ['c:\username\20200907\',fileName,'.vbs'];

% ��ʼдVBS�ű�
fid = fopen(tmpScriptFile, 'wt'); % 'wt'��ʾ���ı�ģʽ���ļ�����д������ԭ������

% ����һ���µĹ��̲�����һ���µ����
hfssNewProject(fid);
hfssInsertDesign(fid, fileName);

% ��������
hfssAddVar(fid, 'p', p, units);
hfssAddVar(fid, 'h', h, units);
hfssAddVar(fid, 'hh', hh, units);
hfssAddVar(fid, 'l', l, units);
hfssAddVar(fid, 'w', w, units);
hfssAddVar(fid, 'll', ll, units);
hfssAddVar(fid, 'ww', ww, units);

% �����Ż�����
hfssAddOptVar(fid, 't', t, units2)

% ��������
hfssAddMaterial(fid, 'PMMA', 2.57, 0.0078);
% FSS�ײ㽨ģ�����ò���
hfssBox(fid, 'shi', [-ww/2-ll+p/2, p/2-ww/2, -h-hh], [2*ll+ww, ww, h], units);
hfssBox(fid, 'shi_1', [p/2-ww/2, -ww/2-ll+p/2, -h-hh], [ww, 2*ll+ww, h], units);
hfssUnite(fid, {'shi', 'shi_1'});
% FSS���㽨ģ�����ò���
hfssBox(fid, 'y', [-l-sqrt(3)*w/6, -w/2, 0], [l+sqrt(3)*w/6, w, h], units);
hfssDuplicateAroundAxis(fid, {'y'}, 'Z', 120, 3);
hfssUnite(fid, {'y', 'y_1', 'y_2'});
hfssDuplicateAlongLine(fid, {'y'}, [p, 0, 0], 2, units);
hfssDuplicateAlongLine(fid, {'y', 'y_3'}, [0, p, 0], 2, units);

% FSS���彨ģ
hfssBox(fid, 'shang', [-p/2, -p/2, h], [2*p, 2*p, hh], units);
hfssBox(fid, 'zhong', [-p/2, -p/2, -hh], [2*p, 2*p, hh], units);
hfssBox(fid, 'xia', [-p/2, -p/2, -h-2*hh], [2*p, 2*p, hh], units);
hfssBox(fid, 'ding', [-p/2, -p/2, 0], [2*p, 2*p, h], units);
hfssSubtract(fid, 'ding', {'y', 'y_3', 'y_3_1', 'y_4'});
hfssBox(fid, 'di', [-p/2, -p/2, -h-hh], [2*p, 2*p, h], units);
hfssSubtract(fid, 'di', 'shi');
hfssUnite(fid, {'shang', 'zhong', 'xia', 'y', 'y_3', 'y_3_1', 'y_4', 'shi'});
hfssAssignMaterial(fid, 'shang', 'PMMA');

% FSS�������ӽ�ģ�����ò���
hfssBox(fid, 'AirBox', [-p/2, -p/2, -50], [2*p, 2*p, 100], units);
hfssAssignMaterial(fid, 'AirBox', 'vacuum');

% �������ӱ߽�����1
hfssMaster(fid, 'Master1', 1121, [3*p/2, 3*p/2, -50], [3*p/2, 3*p/2, 0], units);
hfssSlave(fid, 'Slave1' , 1119, [-p/2, 3*p/2, -50], [-p/2, 3*p/2, 0], units, 'Master1', ['t', units2]);

% �������ӱ߽�����2
hfssMaster(fid, 'Master2', 1120, [-p/2, 3*p/2, -50], [-p/2, 3*p/2, 0], units);
hfssSlave(fid, 'Slave2', 1118, [-p/2, -p/2, -50], [-p/2, -p/2, 0], units, 'Master2', ['t', units2]);

% �������뵼��߽�����
hfssAssignMaterial(fid, 'ding', 'pec');

% ����FloquetPort����
hfssFloquetPort(fid, 'FloquetPort1', 1116, [-p/2, -p/2, 50], [3*p/2, -p/2, 50], [-p/2, 3*p/2, 50], units);
hfssFloquetPort(fid, 'FloquetPort2', 1117, [-p/2, -p/2, -50], [3*p/2, -p/2, -50], [-p/2, 3*p/2, -50], units);

% �������
hfssInsertSolution(fid, 'Setup1', 13, 0.02, 20);

% ɨƵ����
hfssInterpolatingSweep(fid, 'Sweep', 'Setup1', 11, 15, 400, 250, 0.5);

% �����Ż����
hfssOptiParametric(fid, 't', 'Setup1', 't', [0, 60, 15], units2);

% �������ӱ߽�����������Ƕ�
hfssEditSlave(fid, 'Slave1', [-p/2, 3*p/2, -50], [-p/2, 3*p/2, 0], units, 'Master1', 't');
hfssEditSlave(fid, 'Slave2', [-p/2, -p/2, -50], [-p/2, -p/2, 0], units, 'Master2', 't');

% ������Ŀ
hfssSaveProject(fid, 'c:\username\20200907\matlabhfss.aedt', true);

% ���
hfssAnalyze(fid, 't');

% ���ɽ������
hfssCreateRectangularPlot(fid, 'S11y', 'Setup1 : Sweep', 'p', 'h', 't', 'dB(S(FloquetPort1:1,FloquetPort1:1))');

% ��������
hfssReportExport(fid, 'S11y', 'c:\username\20200907\matlabhfssy.csv');

% ��������ģ�ͼ���������һ�ֹ��������з���
hfssAssignMaterial(fid, 'ding', 'vacuum');
hfssAssignMaterial(fid, 'di', 'pec'); 
hfssInsertSolution(fid, 'Setup2', 5, 0.02, 20);
hfssInterpolatingSweep(fid, 'Sweep2', 'Setup2', 3, 7, 400, 250, 0.5);
hfssOptiParametric(fid, 't2', 'Setup2', 't', [0, 60, 15], units2);
hfssAnalyze(fid, 't2');
hfssCreateRectangularPlot(fid, 'S11t', 'Setup2 : Sweep2', 'p', 'h', 't', 'dB(S(FloquetPort1:1,FloquetPort1:1))');
hfssReportExport(fid, 'S11t', 'c:\username\20200907\matlabhfsst.csv');

% �ر������
fclose(fid);