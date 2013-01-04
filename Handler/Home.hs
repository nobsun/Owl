{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home 
       ( getHomeR
       , postAccountIdR
       , postPasswordR
       , postEmailR
       ) where

import Import
import Yesod.Auth
import qualified Data.Text as T
import Owl.Helpers.Form
import Owl.Helpers.Util (newIdent4)
import Owl.Helpers.Widget

getHomeR :: Handler RepHtml
getHomeR = do
  u <- requireAuth
  (menu1, menu2, menu3, menu4) <- newIdent4
  tabIs <- fmap (maybe ("account-id"==) (==)) $ lookupGetParam "tab"
  mmsg <- getMessage
  defaultLayout $ do
    setTitle "Home"
    $(widgetFile "homepage")

postAccountIdR :: Handler ()
postAccountIdR = do
  ((r, _), _) <- runFormPost $ accountForm Nothing
  case r of
    FormSuccess x -> do
      liftIO $ putStrLn $ "[TODO] update user account " ++ T.unpack x
      setMessage "Update account..."
    _ -> setMessage "Fail to update"
  redirect ((HOME HomeR), [("tab", "account-id")])

postPasswordR :: Handler ()
postPasswordR = do
  ((r, _), _) <- runFormPost $ passwordForm Nothing
  case r of
    FormSuccess x -> do
      liftIO $ putStrLn $ "[TODO] update password " ++ T.unpack x
      setMessage "Update password..."
    FormFailure (x:_) -> setMessage $ toHtml x
    _ -> setMessage "Fail to Update"
  redirect ((HOME HomeR), [("tab", "password")])

postEmailR :: Handler ()
postEmailR = do
  ((r, _), _) <- runFormPost $ emailForm [] Nothing
  case r of
    FormSuccess x -> do
      liftIO $ putStrLn $ "[TODO] send email reminder " ++ T.unpack x
      setMessage "Send email reminder"
    FormFailure (x:_) -> setMessage $ toHtml x
    _ -> setMessage "Fail to send"
  redirect ((HOME HomeR), [("tab", "email")])
