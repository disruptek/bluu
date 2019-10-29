
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-TextAnalytics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Entities_563778 = ref object of OpenApiRestCall_563556
proc url_Entities_563780(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Entities_563779(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563941 = query.getOrDefault("showStats")
  valid_563941 = validateParameter(valid_563941, JBool, required = false, default = nil)
  if valid_563941 != nil:
    section.add "showStats", valid_563941
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

proc call*(call_563965: Call_Entities_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ## 
  let valid = call_563965.validator(path, query, header, formData, body)
  let scheme = call_563965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563965.url(scheme.get, call_563965.host, call_563965.base,
                         call_563965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563965, url, valid)

proc call*(call_564036: Call_Entities_563778;
          multiLanguageBatchInput: JsonNode = nil; showStats: bool = false): Recallable =
  ## entities
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  var query_564037 = newJObject()
  var body_564039 = newJObject()
  if multiLanguageBatchInput != nil:
    body_564039 = multiLanguageBatchInput
  add(query_564037, "showStats", newJBool(showStats))
  result = call_564036.call(nil, query_564037, nil, nil, body_564039)

var entities* = Call_Entities_563778(name: "entities", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/entities",
                                  validator: validate_Entities_563779, base: "",
                                  url: url_Entities_563780,
                                  schemes: {Scheme.Https})
type
  Call_KeyPhrases_564078 = ref object of OpenApiRestCall_563556
proc url_KeyPhrases_564080(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KeyPhrases_564079(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564081 = query.getOrDefault("showStats")
  valid_564081 = validateParameter(valid_564081, JBool, required = false, default = nil)
  if valid_564081 != nil:
    section.add "showStats", valid_564081
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

proc call*(call_564083: Call_KeyPhrases_564078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ## 
  let valid = call_564083.validator(path, query, header, formData, body)
  let scheme = call_564083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564083.url(scheme.get, call_564083.host, call_564083.base,
                         call_564083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564083, url, valid)

proc call*(call_564084: Call_KeyPhrases_564078;
          multiLanguageBatchInput: JsonNode = nil; showStats: bool = false): Recallable =
  ## keyPhrases
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze. Documents can now contain a language field to indicate the text language
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  var query_564085 = newJObject()
  var body_564086 = newJObject()
  if multiLanguageBatchInput != nil:
    body_564086 = multiLanguageBatchInput
  add(query_564085, "showStats", newJBool(showStats))
  result = call_564084.call(nil, query_564085, nil, nil, body_564086)

var keyPhrases* = Call_KeyPhrases_564078(name: "keyPhrases",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keyPhrases",
                                      validator: validate_KeyPhrases_564079,
                                      base: "", url: url_KeyPhrases_564080,
                                      schemes: {Scheme.Https})
type
  Call_DetectLanguage_564087 = ref object of OpenApiRestCall_563556
proc url_DetectLanguage_564089(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DetectLanguage_564088(path: JsonNode; query: JsonNode;
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
  var valid_564090 = query.getOrDefault("showStats")
  valid_564090 = validateParameter(valid_564090, JBool, required = false, default = nil)
  if valid_564090 != nil:
    section.add "showStats", valid_564090
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

proc call*(call_564092: Call_DetectLanguage_564087; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ## 
  let valid = call_564092.validator(path, query, header, formData, body)
  let scheme = call_564092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564092.url(scheme.get, call_564092.host, call_564092.base,
                         call_564092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564092, url, valid)

proc call*(call_564093: Call_DetectLanguage_564087;
          languageBatchInput: JsonNode = nil; showStats: bool = false): Recallable =
  ## detectLanguage
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ##   languageBatchInput: JObject
  ##                     : Collection of documents to analyze.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  var query_564094 = newJObject()
  var body_564095 = newJObject()
  if languageBatchInput != nil:
    body_564095 = languageBatchInput
  add(query_564094, "showStats", newJBool(showStats))
  result = call_564093.call(nil, query_564094, nil, nil, body_564095)

var detectLanguage* = Call_DetectLanguage_564087(name: "detectLanguage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/languages",
    validator: validate_DetectLanguage_564088, base: "", url: url_DetectLanguage_564089,
    schemes: {Scheme.Https})
type
  Call_Sentiment_564096 = ref object of OpenApiRestCall_563556
proc url_Sentiment_564098(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Sentiment_564097(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564099 = query.getOrDefault("showStats")
  valid_564099 = validateParameter(valid_564099, JBool, required = false, default = nil)
  if valid_564099 != nil:
    section.add "showStats", valid_564099
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

proc call*(call_564101: Call_Sentiment_564096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_Sentiment_564096;
          multiLanguageBatchInput: JsonNode = nil; showStats: bool = false): Recallable =
  ## sentiment
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  var query_564103 = newJObject()
  var body_564104 = newJObject()
  if multiLanguageBatchInput != nil:
    body_564104 = multiLanguageBatchInput
  add(query_564103, "showStats", newJBool(showStats))
  result = call_564102.call(nil, query_564103, nil, nil, body_564104)

var sentiment* = Call_Sentiment_564096(name: "sentiment", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/sentiment",
                                    validator: validate_Sentiment_564097,
                                    base: "", url: url_Sentiment_564098,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
