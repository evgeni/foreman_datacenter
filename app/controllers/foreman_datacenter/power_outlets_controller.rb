module ForemanDatacenter
  class PowerOutletsController < ApplicationController
    before_action :set_power_outlet, only: [:edit, :update, :destroy, :new_connection,
                                            :connect, :disconnect]

    def new
      device = Device.find(params[:device_id])
      @power_outlet = PowerOutlet.new(device: device)
    end

    def edit
    end

    def create
      @power_outlet = PowerOutlet.new(power_outlet_params)

      if @power_outlet.save
        redirect_to device_url(id: @power_outlet.device_id),
                    notice: 'Power outlet was successfully created.'
      else
        process_error object: @power_outlet
      end
    end

    def update
      if @power_outlet.update(power_outlet_params)
        redirect_to device_url(id: @power_outlet.device_id),
                    notice: 'Power outlet was successfully updated.'
      else
        process_error object: @power_outlet
      end
    end

    def destroy
      if @power_outlet.destroy
        redirect_to device_url(id: @power_outlet.device_id),
                    notice: 'Power outlet was successfully destroyed.'
      else
        process_error object: @power_outlet
      end
    end

    def new_connection
    end

    def connect
      power_port = PowerPort.find(params[:power_port][:id])
      power_port.connect(
        @power_outlet,
        params[:power_port][:connection_status]
      )
      redirect_to device_url(id: @power_outlet.device_id),
                  notice: 'Power outlet was successfully connected.'
    end

    def disconnect
      @power_outlet.power_port.disconnect
      redirect_to device_url(id: @power_outlet.device_id),
                  notice: 'Power outlet was successfully disconnected.'
    end

    private

    def set_power_outlet
      @power_outlet = PowerOutlet.find(params[:id])
    end

    def power_outlet_params
      params[:power_outlet].permit(:device_id, :name)
    end
  end
end
