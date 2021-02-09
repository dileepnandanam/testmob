class ApiDocsController < ApplicationController
  def index
    @api_doc = ApiDoc.first
    render 'show'
  end

  def new
    @api_doc = ApiDoc.new
  end

  def edit
    @api_doc = ApiDoc.find(params[:id])
  end

  def show
    @api_doc = ApiDoc.find(params[:id])
  end

  def create
    unless current_user.try(:usertype) == 'platform'
      redirect_to api_docs_path and return
    end
    @api_doc = ApiDoc.new(api_doc_params)
    if @api_doc.save
      redirect_to api_docs_path
    else
      render 'new'
    end
  end

  def update
    unless current_user.try(:usertype) == 'platform'
      redirect_to api_docs_path and return
    end
    @api_doc = ApiDoc.find(params[:id])
    if @api_doc.update(api_doc_params)
      redirect_to api_docs_path
    else
      render 'edit'
    end
  end

  protected

  def api_doc_params
    params.require(:api_doc).permit(:name, :content)
  end
end