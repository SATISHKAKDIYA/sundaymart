<?php

namespace App\Repositories;

abstract class CoreRepository
{
    protected $model;

    /**
     * CoreRepository constructor.
     */
    public function __construct()
    {
        $this->model = app($this->getModelClass());
    }

    abstract protected function getModelClass();

    protected function startCondition(){
        return clone $this->model;
    }

    public function getById($id){
        return $this->startCondition()->find($id);
    }

}
