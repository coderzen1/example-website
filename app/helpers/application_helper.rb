module ApplicationHelper

  def inline_svg(image_path, options = {})
    file = File.read(Rails.root.join('app', 'assets', 'images', image_path))
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    if options[:id].present?
      svg['id'] = options[:id]
    end
    doc.to_html.html_safe
  end

  def nav_link(text, path, options = {})
    if options[:class].present?
      options[:class] += ' __link js-navigation-link'
    else
      options[:class] = '__link js-navigation-link'
    end

    options[:class] += ' __link--active js-navigation-link--active' if request.path.include?(path)
    link_to(text, path, options)
  end

  def meta_tag_options
    {
      description: I18n.t('application_description', locale: 'en'),
      og: {
        title: I18n.t('application_name', locale: 'en'),
        description: t('application_description', locale: 'en'),
        type:  'website',
        url:   root_url,
        image: image_url('/facebook_share_pic.png'),
        description: I18n.t('application_description'),
      },
      twitter: {
        card: 'summary_large_image',
        site: '@foodfave',
        title: I18n.t('application_name', locale: 'en'),
        description: I18n.t('application_description', locale: 'en'),
        image: image_url('/twitter_share_pic.png'),
      }
    }
  end
end
