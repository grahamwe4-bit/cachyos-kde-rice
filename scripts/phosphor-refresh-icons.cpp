#include <QApplication>
#include <QTimer>
#include <KIconLoader>
int main(int argc,char **argv){QApplication app(argc,argv);for(int i=0;i<KIconLoader::LastGroup;++i)KIconLoader::emitChange(static_cast<KIconLoader::Group>(i));QTimer::singleShot(300,&app,&QCoreApplication::quit);return app.exec();}
