require File.expand_path('../../config/environment', __dir__)

namespace :pinger do
  namespace :with_hash do
    task :start do
      PingerWithHash.new.perform
    end
  end

  namespace :with_pool do
    task :start do
      PingerWithPool.new.perform
    end
  end
end
