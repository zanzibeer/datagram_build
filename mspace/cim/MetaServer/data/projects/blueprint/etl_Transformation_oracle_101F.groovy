import ru.neoflex.meta.utils.Context
def session = Context.current.txSession
def entity = session.createQuery("from etl.Transformation where name = :name").setParameter("name", "oracle_101F").uniqueResult() 
entity.userDefinedFunctions.clear()
entity.mavenDependencies.clear()
entity.project = session.createQuery("from etl.Project where name = :name").setParameter("name", "blueprint").uniqueResult()
entity.targets.find {it.name == "F101_detailed"}.context = null
entity.targets.find {it.name == "F101_LEDGER_ACCOUNT"}.context = null
entity.sources.find {it.name == "DM_CUSTOMER_D"}.context = session.createQuery("from etl.JdbcContext where name = :name").setParameter("name", "oracle").uniqueResult()
entity.sources.find {it.name == "DM_ACCOUNT_TURNOVER_F"}.context = session.createQuery("from etl.JdbcContext where name = :name").setParameter("name", "oracle").uniqueResult()
entity.sources.find {it.name == "DM_BALANCE_F"}.context = session.createQuery("from etl.JdbcContext where name = :name").setParameter("name", "oracle").uniqueResult()
entity.sources.find {it.name == "DM_ACCOUNT_D"}.context = session.createQuery("from etl.JdbcContext where name = :name").setParameter("name", "oracle").uniqueResult()
Context.current.commit()
