require 'base64'

class PdfRenderer
  Loader = org.apache.pdfbox.Loader
  PDDocument = org.apache.pdfbox.pdmodel.PDDocument
  PDFRenderer = org.apache.pdfbox.rendering.PDFRenderer
  ImageType = org.apache.pdfbox.rendering.ImageType
  BufferedImage = java.awt.image.BufferedImage
  ImageIO = javax.imageio.ImageIO
  ByteArrayOutputStream = java.io.ByteArrayOutputStream
  AffineTransform = java.awt.geom.AffineTransform
  AffineTransformOp = java.awt.image.AffineTransformOp
  File = java.io.File

  def self.first_page_data_url(pdf_path, width)
    document = Loader.loadPDF(File.new(pdf_path))
    renderer = PDFRenderer.new(document)

    # Render the first page at 25%
    image = renderer.renderImage(0, 0.25, ImageType::RGB)

    # Calculate scale to reach target width
    orig_width = image.getWidth
    orig_height = image.getHeight

    scale = width.to_f / orig_width
    new_width = width.to_i
    new_height = (orig_height * scale).round

    transform = AffineTransform.getScaleInstance(scale, scale)
    op = AffineTransformOp.new(transform, AffineTransformOp::TYPE_BILINEAR)

    scaled_image = BufferedImage.new(new_width, new_height, BufferedImage::TYPE_INT_RGB)
    op.filter(image, scaled_image)

    # Convert to PNG and encode as Base64
    out = ByteArrayOutputStream.new
    ImageIO.write(scaled_image, "png", out)
    out.flush

    base64 = Base64.strict_encode64(out.toByteArray.to_a.pack("C*"))
    "data:image/png;base64,#{base64}"
  ensure
    document&.close
  end
end
