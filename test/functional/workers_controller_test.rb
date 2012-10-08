require 'test_helper'

class WorkersControllerTest < ActionController::TestCase
  setup do
    @worker = workers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create worker" do
    assert_difference('Worker.count') do
      post :create, worker: { wrk_description: @worker.wrk_description, wrk_hashed_password: @worker.wrk_hashed_password, wrk_host: @worker.wrk_host, wrk_name: @worker.wrk_name, wrk_port: @worker.wrk_port, wrk_type: @worker.wrk_type, wrk_user: @worker.wrk_user }
    end

    assert_redirected_to worker_path(assigns(:worker))
  end

  test "should show worker" do
    get :show, id: @worker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @worker
    assert_response :success
  end

  test "should update worker" do
    put :update, id: @worker, worker: { wrk_description: @worker.wrk_description, wrk_hashed_password: @worker.wrk_hashed_password, wrk_host: @worker.wrk_host, wrk_name: @worker.wrk_name, wrk_port: @worker.wrk_port, wrk_type: @worker.wrk_type, wrk_user: @worker.wrk_user }
    assert_redirected_to worker_path(assigns(:worker))
  end

  test "should destroy worker" do
    assert_difference('Worker.count', -1) do
      delete :destroy, id: @worker
    end

    assert_redirected_to workers_path
  end
end
