
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Text Analytics Client
## version: v2.1
## termsOfService: (not provided)
## license: (not provided)
## 
## The Text Analytics API is a suite of text analytics web services built with best-in-class Microsoft machine learning algorithms. The API can be used to analyze unstructured text for tasks such as sentiment analysis, key phrase extraction and language detection. No training data is needed to use this API; just bring your text data. This API uses advanced natural language processing techniques to deliver best in class predictions. Further documentation can be found in https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-TextAnalytics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Entities_593647 = ref object of OpenApiRestCall_593425
proc url_Entities_593649(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Entities_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   showStats: JBool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  section = newJObject()
  var valid_593808 = query.getOrDefault("showStats")
  valid_593808 = validateParameter(valid_593808, JBool, required = false, default = nil)
  if valid_593808 != nil:
    section.add "showStats", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593832: Call_Entities_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_Entities_593647; showStats: bool = false;
          multiLanguageBatchInput: JsonNode = nil): Recallable =
  ## entities
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  var query_593904 = newJObject()
  var body_593906 = newJObject()
  add(query_593904, "showStats", newJBool(showStats))
  if multiLanguageBatchInput != nil:
    body_593906 = multiLanguageBatchInput
  result = call_593903.call(nil, query_593904, nil, nil, body_593906)

var entities* = Call_Entities_593647(name: "entities", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/entities",
                                  validator: validate_Entities_593648, base: "",
                                  url: url_Entities_593649,
                                  schemes: {Scheme.Https})
type
  Call_KeyPhrases_593945 = ref object of OpenApiRestCall_593425
proc url_KeyPhrases_593947(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KeyPhrases_593946(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   showStats: JBool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  section = newJObject()
  var valid_593948 = query.getOrDefault("showStats")
  valid_593948 = validateParameter(valid_593948, JBool, required = false, default = nil)
  if valid_593948 != nil:
    section.add "showStats", valid_593948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze. Documents can now contain a language field to indicate the text language
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593950: Call_KeyPhrases_593945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ## 
  let valid = call_593950.validator(path, query, header, formData, body)
  let scheme = call_593950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593950.url(scheme.get, call_593950.host, call_593950.base,
                         call_593950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593950, url, valid)

proc call*(call_593951: Call_KeyPhrases_593945; showStats: bool = false;
          multiLanguageBatchInput: JsonNode = nil): Recallable =
  ## keyPhrases
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze. Documents can now contain a language field to indicate the text language
  var query_593952 = newJObject()
  var body_593953 = newJObject()
  add(query_593952, "showStats", newJBool(showStats))
  if multiLanguageBatchInput != nil:
    body_593953 = multiLanguageBatchInput
  result = call_593951.call(nil, query_593952, nil, nil, body_593953)

var keyPhrases* = Call_KeyPhrases_593945(name: "keyPhrases",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keyPhrases",
                                      validator: validate_KeyPhrases_593946,
                                      base: "", url: url_KeyPhrases_593947,
                                      schemes: {Scheme.Https})
type
  Call_DetectLanguage_593954 = ref object of OpenApiRestCall_593425
proc url_DetectLanguage_593956(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DetectLanguage_593955(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   showStats: JBool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  section = newJObject()
  var valid_593957 = query.getOrDefault("showStats")
  valid_593957 = validateParameter(valid_593957, JBool, required = false, default = nil)
  if valid_593957 != nil:
    section.add "showStats", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   languageBatchInput: JObject
  ##                     : Collection of documents to analyze.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593959: Call_DetectLanguage_593954; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ## 
  let valid = call_593959.validator(path, query, header, formData, body)
  let scheme = call_593959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593959.url(scheme.get, call_593959.host, call_593959.base,
                         call_593959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593959, url, valid)

proc call*(call_593960: Call_DetectLanguage_593954;
          languageBatchInput: JsonNode = nil; showStats: bool = false): Recallable =
  ## detectLanguage
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ##   languageBatchInput: JObject
  ##                     : Collection of documents to analyze.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  var query_593961 = newJObject()
  var body_593962 = newJObject()
  if languageBatchInput != nil:
    body_593962 = languageBatchInput
  add(query_593961, "showStats", newJBool(showStats))
  result = call_593960.call(nil, query_593961, nil, nil, body_593962)

var detectLanguage* = Call_DetectLanguage_593954(name: "detectLanguage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/languages",
    validator: validate_DetectLanguage_593955, base: "", url: url_DetectLanguage_593956,
    schemes: {Scheme.Https})
type
  Call_Sentiment_593963 = ref object of OpenApiRestCall_593425
proc url_Sentiment_593965(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Sentiment_593964(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   showStats: JBool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  section = newJObject()
  var valid_593966 = query.getOrDefault("showStats")
  valid_593966 = validateParameter(valid_593966, JBool, required = false, default = nil)
  if valid_593966 != nil:
    section.add "showStats", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_Sentiment_593963; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_Sentiment_593963; showStats: bool = false;
          multiLanguageBatchInput: JsonNode = nil): Recallable =
  ## sentiment
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  var query_593970 = newJObject()
  var body_593971 = newJObject()
  add(query_593970, "showStats", newJBool(showStats))
  if multiLanguageBatchInput != nil:
    body_593971 = multiLanguageBatchInput
  result = call_593969.call(nil, query_593970, nil, nil, body_593971)

var sentiment* = Call_Sentiment_593963(name: "sentiment", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/sentiment",
                                    validator: validate_Sentiment_593964,
                                    base: "", url: url_Sentiment_593965,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
