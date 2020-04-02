#ifndef _HelloImp_H_
#define _HelloImp_H_

#include "servant/Application.h"
#include "Hello.h"

/**
 *
 *
 */
class HelloImp : public tars::Servant 
{
public:
    /**
     *
     */
    virtual ~HelloImp() {}

    /**
     *
     */
    virtual void initialize();

    /**
     *
     */
    virtual void destroy();

    /**
     *
     */
    virtual int doRequest(tars::TarsCurrentPtr current, vector<char> &buffer);

protected:
    Demo::HelloPrx _helloPrx;
};
/////////////////////////////////////////////////////
#endif
