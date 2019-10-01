
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  Call_Entities_567880 = ref object of OpenApiRestCall_567658
proc url_Entities_567882(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Entities_567881(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568041 = query.getOrDefault("showStats")
  valid_568041 = validateParameter(valid_568041, JBool, required = false, default = nil)
  if valid_568041 != nil:
    section.add "showStats", valid_568041
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

proc call*(call_568065: Call_Entities_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_Entities_567880; showStats: bool = false;
          multiLanguageBatchInput: JsonNode = nil): Recallable =
  ## entities
  ## To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  var query_568137 = newJObject()
  var body_568139 = newJObject()
  add(query_568137, "showStats", newJBool(showStats))
  if multiLanguageBatchInput != nil:
    body_568139 = multiLanguageBatchInput
  result = call_568136.call(nil, query_568137, nil, nil, body_568139)

var entities* = Call_Entities_567880(name: "entities", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/entities",
                                  validator: validate_Entities_567881, base: "",
                                  url: url_Entities_567882,
                                  schemes: {Scheme.Https})
type
  Call_KeyPhrases_568178 = ref object of OpenApiRestCall_567658
proc url_KeyPhrases_568180(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KeyPhrases_568179(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568181 = query.getOrDefault("showStats")
  valid_568181 = validateParameter(valid_568181, JBool, required = false, default = nil)
  if valid_568181 != nil:
    section.add "showStats", valid_568181
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

proc call*(call_568183: Call_KeyPhrases_568178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ## 
  let valid = call_568183.validator(path, query, header, formData, body)
  let scheme = call_568183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568183.url(scheme.get, call_568183.host, call_568183.base,
                         call_568183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568183, url, valid)

proc call*(call_568184: Call_KeyPhrases_568178; showStats: bool = false;
          multiLanguageBatchInput: JsonNode = nil): Recallable =
  ## keyPhrases
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze. Documents can now contain a language field to indicate the text language
  var query_568185 = newJObject()
  var body_568186 = newJObject()
  add(query_568185, "showStats", newJBool(showStats))
  if multiLanguageBatchInput != nil:
    body_568186 = multiLanguageBatchInput
  result = call_568184.call(nil, query_568185, nil, nil, body_568186)

var keyPhrases* = Call_KeyPhrases_568178(name: "keyPhrases",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keyPhrases",
                                      validator: validate_KeyPhrases_568179,
                                      base: "", url: url_KeyPhrases_568180,
                                      schemes: {Scheme.Https})
type
  Call_DetectLanguage_568187 = ref object of OpenApiRestCall_567658
proc url_DetectLanguage_568189(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DetectLanguage_568188(path: JsonNode; query: JsonNode;
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
  var valid_568190 = query.getOrDefault("showStats")
  valid_568190 = validateParameter(valid_568190, JBool, required = false, default = nil)
  if valid_568190 != nil:
    section.add "showStats", valid_568190
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

proc call*(call_568192: Call_DetectLanguage_568187; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ## 
  let valid = call_568192.validator(path, query, header, formData, body)
  let scheme = call_568192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568192.url(scheme.get, call_568192.host, call_568192.base,
                         call_568192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568192, url, valid)

proc call*(call_568193: Call_DetectLanguage_568187;
          languageBatchInput: JsonNode = nil; showStats: bool = false): Recallable =
  ## detectLanguage
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ##   languageBatchInput: JObject
  ##                     : Collection of documents to analyze.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  var query_568194 = newJObject()
  var body_568195 = newJObject()
  if languageBatchInput != nil:
    body_568195 = languageBatchInput
  add(query_568194, "showStats", newJBool(showStats))
  result = call_568193.call(nil, query_568194, nil, nil, body_568195)

var detectLanguage* = Call_DetectLanguage_568187(name: "detectLanguage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/languages",
    validator: validate_DetectLanguage_568188, base: "", url: url_DetectLanguage_568189,
    schemes: {Scheme.Https})
type
  Call_Sentiment_568196 = ref object of OpenApiRestCall_567658
proc url_Sentiment_568198(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Sentiment_568197(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568199 = query.getOrDefault("showStats")
  valid_568199 = validateParameter(valid_568199, JBool, required = false, default = nil)
  if valid_568199 != nil:
    section.add "showStats", valid_568199
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

proc call*(call_568201: Call_Sentiment_568196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_Sentiment_568196; showStats: bool = false;
          multiLanguageBatchInput: JsonNode = nil): Recallable =
  ## sentiment
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ##   showStats: bool
  ##            : (optional) if set to true, response will contain input and document level statistics.
  ##   multiLanguageBatchInput: JObject
  ##                          : Collection of documents to analyze.
  var query_568203 = newJObject()
  var body_568204 = newJObject()
  add(query_568203, "showStats", newJBool(showStats))
  if multiLanguageBatchInput != nil:
    body_568204 = multiLanguageBatchInput
  result = call_568202.call(nil, query_568203, nil, nil, body_568204)

var sentiment* = Call_Sentiment_568196(name: "sentiment", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/sentiment",
                                    validator: validate_Sentiment_568197,
                                    base: "", url: url_Sentiment_568198,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
