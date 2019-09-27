
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Text Analytics Client
## version: v2.1-preview
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
  ## The API returns a list of recognized entities in a given document. To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.The API returns a list of known entities and general named entities ("Person", "Location", "Organization" etc) in a given document. Known entities are returned with Wikipedia Id and Wikipedia link, and also Bing Id which can be used in Bing Entity Search API. General named entities are returned with entity types. If a general named entity is also a known entity, then all information regarding it (Wikipedia Id, Bing Id, entity type etc) will be returned. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking#supported-types-for-named-entity-recognition">Supported Entity Types in Text Analytics API</a> for the list of supported Entity Types. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Collection of documents to analyze.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_Entities_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The API returns a list of recognized entities in a given document. To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.The API returns a list of known entities and general named entities ("Person", "Location", "Organization" etc) in a given document. Known entities are returned with Wikipedia Id and Wikipedia link, and also Bing Id which can be used in Bing Entity Search API. General named entities are returned with entity types. If a general named entity is also a known entity, then all information regarding it (Wikipedia Id, Bing Id, entity type etc) will be returned. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking#supported-types-for-named-entity-recognition">Supported Entity Types in Text Analytics API</a> for the list of supported Entity Types. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_Entities_593647; input: JsonNode): Recallable =
  ## entities
  ## The API returns a list of recognized entities in a given document. To get even more information on each recognized entity we recommend using the Bing Entity Search API by querying for the recognized entities names. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.The API returns a list of known entities and general named entities ("Person", "Location", "Organization" etc) in a given document. Known entities are returned with Wikipedia Id and Wikipedia link, and also Bing Id which can be used in Bing Entity Search API. General named entities are returned with entity types. If a general named entity is also a known entity, then all information regarding it (Wikipedia Id, Bing Id, entity type etc) will be returned. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking#supported-types-for-named-entity-recognition">Supported Entity Types in Text Analytics API</a> for the list of supported Entity Types. See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/text-analytics-supported-languages">Supported languages in Text Analytics API</a> for the list of enabled languages.
  ##   input: JObject (required)
  ##        : Collection of documents to analyze.
  var body_593903 = newJObject()
  if input != nil:
    body_593903 = input
  result = call_593902.call(nil, nil, nil, nil, body_593903)

var entities* = Call_Entities_593647(name: "entities", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/entities",
                                  validator: validate_Entities_593648, base: "",
                                  url: url_Entities_593649,
                                  schemes: {Scheme.Https})
type
  Call_KeyPhrases_593942 = ref object of OpenApiRestCall_593425
proc url_KeyPhrases_593944(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KeyPhrases_593943(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Collection of documents to analyze. Documents can now contain a language field to indicate the text language
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593946: Call_KeyPhrases_593942; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ## 
  let valid = call_593946.validator(path, query, header, formData, body)
  let scheme = call_593946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593946.url(scheme.get, call_593946.host, call_593946.base,
                         call_593946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593946, url, valid)

proc call*(call_593947: Call_KeyPhrases_593942; input: JsonNode): Recallable =
  ## keyPhrases
  ## See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by key phrase extraction.
  ##   input: JObject (required)
  ##        : Collection of documents to analyze. Documents can now contain a language field to indicate the text language
  var body_593948 = newJObject()
  if input != nil:
    body_593948 = input
  result = call_593947.call(nil, nil, nil, nil, body_593948)

var keyPhrases* = Call_KeyPhrases_593942(name: "keyPhrases",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keyPhrases",
                                      validator: validate_KeyPhrases_593943,
                                      base: "", url: url_KeyPhrases_593944,
                                      schemes: {Scheme.Https})
type
  Call_DetectLanguage_593949 = ref object of OpenApiRestCall_593425
proc url_DetectLanguage_593951(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DetectLanguage_593950(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Collection of documents to analyze.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593953: Call_DetectLanguage_593949; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ## 
  let valid = call_593953.validator(path, query, header, formData, body)
  let scheme = call_593953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593953.url(scheme.get, call_593953.host, call_593953.base,
                         call_593953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593953, url, valid)

proc call*(call_593954: Call_DetectLanguage_593949; input: JsonNode): Recallable =
  ## detectLanguage
  ## Scores close to 1 indicate 100% certainty that the identified language is true. A total of 120 languages are supported.
  ##   input: JObject (required)
  ##        : Collection of documents to analyze.
  var body_593955 = newJObject()
  if input != nil:
    body_593955 = input
  result = call_593954.call(nil, nil, nil, nil, body_593955)

var detectLanguage* = Call_DetectLanguage_593949(name: "detectLanguage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/languages",
    validator: validate_DetectLanguage_593950, base: "", url: url_DetectLanguage_593951,
    schemes: {Scheme.Https})
type
  Call_Sentiment_593956 = ref object of OpenApiRestCall_593425
proc url_Sentiment_593958(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Sentiment_593957(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Collection of documents to analyze.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593960: Call_Sentiment_593956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ## 
  let valid = call_593960.validator(path, query, header, formData, body)
  let scheme = call_593960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593960.url(scheme.get, call_593960.host, call_593960.base,
                         call_593960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593960, url, valid)

proc call*(call_593961: Call_Sentiment_593956; input: JsonNode): Recallable =
  ## sentiment
  ## Scores close to 1 indicate positive sentiment, while scores close to 0 indicate negative sentiment. A score of 0.5 indicates the lack of sentiment (e.g. a factoid statement). See the <a href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview#supported-languages">Text Analytics Documentation</a> for details about the languages that are supported by sentiment analysis.
  ##   input: JObject (required)
  ##        : Collection of documents to analyze.
  var body_593962 = newJObject()
  if input != nil:
    body_593962 = input
  result = call_593961.call(nil, nil, nil, nil, body_593962)

var sentiment* = Call_Sentiment_593956(name: "sentiment", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/sentiment",
                                    validator: validate_Sentiment_593957,
                                    base: "", url: url_Sentiment_593958,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
