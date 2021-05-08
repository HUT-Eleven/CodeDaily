package com.atguigu.app;

/**
 * @author Administrator
 *
 */
public class NoRaffleState extends State {

	 // ��ʼ��ʱ�������ã��۳����ֺ�ı���״̬
    RaffleActivity activity;

    public NoRaffleState(RaffleActivity activity) {
        this.activity = activity;
    }

    @Override
    public void deductMoney() {
        System.out.println("�۳�50���ֳɹ��������Գ齱��");
        activity.setState(activity.getCanRaffleState());
    }

    @Override
    public boolean raffle() {
        System.out.println("���˻��ֲ��ܳ齱ร�");
        return false;
    }

    @Override
    public void dispensePrize() {
        System.out.println("���ܷ��Ž�Ʒ");
    }
}
