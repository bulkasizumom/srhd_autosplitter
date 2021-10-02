/* 
 * author: _bulka_s_izumom
 * discord: _bulka_s_izumom#3860
 * speedrun.com: https://www.speedrun.com/user/_bulka_s_izumom
 * 
 * Что работает:
 * -таймер запускается в момент начала игры сразу после появления в центре рейнджеров
 * -первый сплит срабатывает в момент взятия кредита в бизнес-центре
 * -следующие три сплита - в моменты смерти боссов(террона, блазера, келлера)
 * -последний - в момент появления титров после финального диалога(и заставки) в центре рейнджеров
 *
 * Проблемы:
 * -при загрузке сохранения(или выходе из игры) после смерти всех трёх боссов срабатывает сплит
 *     происходит это потому что для финального сплита было выбрано условие: 
 *     [количество медалей у гг в данный момент - 0(после появления титров все значения обнуляются, как и при загрузках),
 *     а в предыдущий момент - больше двух(на момент финального диалога гг выдают 3 медали)],
 *     но условие выполняется не только в момент получения медалей в центре рейнджеров,  
 *     но и когда гг только получил извещение о том, что ему необходимо за ними явиться.
 * -таймер не сбрасывается в момент выхода игрока в главное меню или при закрытии игры(не реализовано)
 * -при сбрасывании таймера в самый первый день внутриигрового мремени, он запустится снова, 
 *     так как для старта таймера выполняется условие:
 *     [дата соответствует 1 января 3300 года(первый игровой день)]
 */


state("Rangers")
{
    int terron_hp:          0x460DD0, 0x3CC, 0xC, 0xF8, 0x70;
    int blazer_hp:          0x460DC8, 0x3B8, 0x4, 0x0, 0x7C, 0xF8, 0x70;
    int keller_hp:          0x4542A8, 0xE4, 0x4, 0x0, 0x8, 0x4, 0xB0;
    int datetime:           0x453FAC, 0x18, 0xCC, 0x44, 0x128, 0x4, 0xC, 0x0;
    int credits:            0x460DFC, 0x20, 0x4, 0x0, 0xC, 0xF8, 0x7C, 0xF0;
    int ship_durability:    0x4612D8, 0x3C, 0x4, 0x0, 0xF8, 0x18;
    int medals:             0x4612D8, 0x3C, 0x4, 0x0, 0x3EC;
}

start
{
    /* игра начинается 1 января 3300 года, значение 2097201 соответствует этой дате*/
    if(current.datetime == 2097201)
    {
        return true;
    }
}

split
{
    if((current.terron_hp < old.terron_hp && current.terron_hp == 0 && current.ship_durability > 0 && current.datetime != 0) 
    || (current.blazer_hp < old.blazer_hp && current.blazer_hp == 0 && current.ship_durability > 0 && current.datetime != 0) 
    || (current.keller_hp < old.keller_hp && current.keller_hp == 0 && old.keller_hp < 2000) 
    || (current.credits > old.credits && current.credits > 100000 && old.credits < 10000 && old.credits != 0 && current.ship_durability > 0 && current.datetime != 0))
    {
        return true;
    }
    if(old.medals > 2 && current.medals == 0)
    {
        return true;
    }
}