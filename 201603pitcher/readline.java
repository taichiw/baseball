import java.nio.file.*
import java.util.stream.Stream

//jshell note
//setstart�Ɉ��K���ȏ�������ꂽ��ċN�����Ă������Ȃ��Ȃ����B�߂����킩�炸�A����t�@�C���������setstart dummy. ���̂��Ƃ���t�@�C���������Ă����Ȃ������Ă��B
//import���肪�����������₷���Ƃ����Ȃ�
//jshell�֌W�Ȃ����ǁ@���\�b�h�`�F�[���̃C���f���g���Ă݂�Ȃǂ������Ă�́H
//open�R�}���h�֗�...�@�Ǝv���Ă����ǁA�N���X��`���悤�Ƃ����炾�񂾂�߂�ǂ��Ȃ��Ă����B�V���^�b�N�X�G���[���ǂ��ŋN�����Ă�̂��킩��ɂ����B���͂�R���p�C�����Ă�̂ƕς��Ȃ�
//���\�b�h�`�F�[���̃h�b�g�𓪂ɂ����Ȃ��iirb�Ȃǂ��������ۂ����j

Files.lines(
	Paths.get("c_pitcher.txt")).
		forEach(
			str -> Arrays.stream(str.split("\t")).
			forEach(System.out::println)).
			collec
