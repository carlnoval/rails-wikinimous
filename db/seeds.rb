# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# def generate_article({article_count, summary_sentence_count, sections_count, section_sentence_count})
# def generate_article counts = { article: 1, summ_sentcs_min: 2, summ_sentcs_max: 4, par_min: 2, par_max: 4, par_sentcs_min: 10, par_sentcs_max: 20 }
def gen_article(article_count, ranges = { summ_sentcs: (2..4), pgraphs: (2..4), pgraphs_sentcs: (4..10), pgraphs_sentc_words: (10..20) })
  article_count.times do
    article = Article.new
    article.title = [Faker::Company.name, Faker::Company.suffix, Faker::Company.buzzword.capitalize, Faker::Company.industry].join(" ")
    article_summary = gen_art_summ(ranges[:summ_sentcs])
    content_paragraphs = gen_paragraphs(ranges[:pgraphs], ranges[:pgraphs_sentcs], ranges[:pgraphs_sentc_words])
    article.content = article_summary << content_paragraphs
    article.save
  end
end

# can be called like: generate_summary min:3, max:4
def gen_art_summ(sentence_range)
  summary_paragraph = []
  rand(sentence_range).times do
    summary_paragraph << ( [Faker::Company.catch_phrase, Faker::Company.bs].join(" ") << "." )
  end
  "<p>#{summary_paragraph.join(" ")}</p>"
end

# def gen_paragraphs(sections_range = (2..4), section_sentence_range = {min: 10, max: 20})
def gen_paragraphs(paragraph_range, sentcs_range, sentc_words)
  overall_content = ""
  rand(paragraph_range).times do
    h2 = [Faker::Company.catch_phrase, Faker::Company.bs].join(" ")
    concat_sentences = ""
    rand(sentcs_range).times do
      concat_sentences << Faker::Lorem.sentence(word_count: sentc_words.min, supplemental: false, random_words_to_add: sentc_words.max)
    end
    overall_content << "<h2>#{h2}</h2>" << "<p>#{concat_sentences}</p>"
  end
  overall_content
end

article_count = 5
puts "Deleting all Articles..."
Article.delete_all
puts "All Articles deleted..."
puts "Creating #{article_count} Articles..."
# article_options = { summ_sentcs: (2..4), pgraphs: (2..4), pgraphs_sentcs: (4..10), pgraphs_sentc_words: (10..20) }
gen_article(article_count)
puts "Done creating new Articles"
