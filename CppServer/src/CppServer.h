#ifndef _CppServer_H_
#define _CppServer_H_

#include <iostream>
#include "servant/Application.h"

using namespace tars;

/**
 *
 **/
class CppServer : public Application
{
public:
    /**
     *
     **/
    virtual ~CppServer() {};

    /**
     *
     **/
    virtual void initialize();

    /**
     *
     **/
    virtual void destroyApp();
};

extern CppServer g_app;

////////////////////////////////////////////
#endif
