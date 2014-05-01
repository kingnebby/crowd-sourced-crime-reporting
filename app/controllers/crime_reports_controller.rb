class CrimeReportsController < ApplicationController
  respond_to :json

  # before_action :set_crime_report, only: [:show, :edit, :update, :destroy]

  # GET /crime_reports
  # GET /crime_reports.json
  def index
    render json: CrimeReport.all()
    # this was failing for some reason.
    # respond_with CrimeReport.all()
  end

  # POST /crime_reports
  # POST /crime_reports.json
  def create
    render json: CrimeReport.create(crime_report_params)
  end

  # DELETE /crime_reports/1
  # DELETE /crime_reports/1.json
  def destroy
    report = CrimeReport.destroy(params[:id])
    render json: report
    # @crime_report.destroy
  end

  def show
    report = CrimeReport.find(params[:id])
    render json: report
  end

  # This is the most basic unitelligent search method I can fathom. Scaling would be a big problem.
  def search
    reports = {}
    if ([:lat, :lng, :starttime, :endtime, :radius].any? {|k| params.key?(k)})
      # Once we start looking into using the time window on this stuff we'll have to move this logic into the model I think.
      reports = CrimeReport.near([params[:lat], params[:lng]], params[:radius]).order(:created_at)
    end
    render json: reports
  end
=begin
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crime_report
      @crime_report = CrimeReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crime_report_params
      params.require(:crime_report).permit(:user, :body, :address, :latitude, :longitude)
    end
=end

  def crime_report_params
    params.require(:crime_report).permit(:user, :body, :address)
  end
    
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery

  after_filter :set_csrf_cookie_for_ng
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected
    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end
end
