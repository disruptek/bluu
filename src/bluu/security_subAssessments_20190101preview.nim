
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2019-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "security-subAssessments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubAssessmentsList_563777 = ref object of OpenApiRestCall_563555
proc url_SubAssessmentsList_563779(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/subAssessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubAssessmentsList_563778(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get security sub-assessments on all your scanned resources inside a scope
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assessmentName: JString (required)
  ##                 : The Assessment Key - Unique key for the assessment type
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_563954 = path.getOrDefault("assessmentName")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "assessmentName", valid_563954
  var valid_563955 = path.getOrDefault("scope")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "scope", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_SubAssessmentsList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get security sub-assessments on all your scanned resources inside a scope
  ## 
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_SubAssessmentsList_563777; assessmentName: string;
          apiVersion: string; scope: string): Recallable =
  ## subAssessmentsList
  ## Get security sub-assessments on all your scanned resources inside a scope
  ##   assessmentName: string (required)
  ##                 : The Assessment Key - Unique key for the assessment type
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_564051 = newJObject()
  var query_564053 = newJObject()
  add(path_564051, "assessmentName", newJString(assessmentName))
  add(query_564053, "api-version", newJString(apiVersion))
  add(path_564051, "scope", newJString(scope))
  result = call_564050.call(path_564051, query_564053, nil, nil, nil)

var subAssessmentsList* = Call_SubAssessmentsList_563777(
    name: "subAssessmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/assessments/{assessmentName}/subAssessments",
    validator: validate_SubAssessmentsList_563778, base: "",
    url: url_SubAssessmentsList_563779, schemes: {Scheme.Https})
type
  Call_SubAssessmentsGet_564092 = ref object of OpenApiRestCall_563555
proc url_SubAssessmentsGet_564094(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  assert "subAssessmentName" in path,
        "`subAssessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/subAssessments/"),
               (kind: VariableSegment, value: "subAssessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubAssessmentsGet_564093(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a security sub-assessment on your scanned resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assessmentName: JString (required)
  ##                 : The Assessment Key - Unique key for the assessment type
  ##   subAssessmentName: JString (required)
  ##                    : The Sub-Assessment Key - Unique key for the sub-assessment type
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assessmentName` field"
  var valid_564095 = path.getOrDefault("assessmentName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "assessmentName", valid_564095
  var valid_564096 = path.getOrDefault("subAssessmentName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subAssessmentName", valid_564096
  var valid_564097 = path.getOrDefault("scope")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "scope", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_SubAssessmentsGet_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a security sub-assessment on your scanned resource
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_SubAssessmentsGet_564092; assessmentName: string;
          apiVersion: string; subAssessmentName: string; scope: string): Recallable =
  ## subAssessmentsGet
  ## Get a security sub-assessment on your scanned resource
  ##   assessmentName: string (required)
  ##                 : The Assessment Key - Unique key for the assessment type
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subAssessmentName: string (required)
  ##                    : The Sub-Assessment Key - Unique key for the sub-assessment type
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(path_564101, "assessmentName", newJString(assessmentName))
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subAssessmentName", newJString(subAssessmentName))
  add(path_564101, "scope", newJString(scope))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var subAssessmentsGet* = Call_SubAssessmentsGet_564092(name: "subAssessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/assessments/{assessmentName}/subAssessments/{subAssessmentName}",
    validator: validate_SubAssessmentsGet_564093, base: "",
    url: url_SubAssessmentsGet_564094, schemes: {Scheme.Https})
type
  Call_SubAssessmentsListAll_564103 = ref object of OpenApiRestCall_563555
proc url_SubAssessmentsListAll_564105(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/subAssessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubAssessmentsListAll_564104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get security sub-assessments on all your scanned resources inside a subscription scope
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564106 = path.getOrDefault("scope")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "scope", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_SubAssessmentsListAll_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get security sub-assessments on all your scanned resources inside a subscription scope
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_SubAssessmentsListAll_564103; apiVersion: string;
          scope: string): Recallable =
  ## subAssessmentsListAll
  ## Get security sub-assessments on all your scanned resources inside a subscription scope
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "scope", newJString(scope))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var subAssessmentsListAll* = Call_SubAssessmentsListAll_564103(
    name: "subAssessmentsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Security/subAssessments",
    validator: validate_SubAssessmentsListAll_564104, base: "",
    url: url_SubAssessmentsListAll_564105, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
