
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "security-subAssessments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubAssessmentsList_573879 = ref object of OpenApiRestCall_573657
proc url_SubAssessmentsList_573881(protocol: Scheme; host: string; base: string;
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

proc validate_SubAssessmentsList_573880(path: JsonNode; query: JsonNode;
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
  var valid_574054 = path.getOrDefault("assessmentName")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = nil)
  if valid_574054 != nil:
    section.add "assessmentName", valid_574054
  var valid_574055 = path.getOrDefault("scope")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "scope", valid_574055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574056 = query.getOrDefault("api-version")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "api-version", valid_574056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574079: Call_SubAssessmentsList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get security sub-assessments on all your scanned resources inside a scope
  ## 
  let valid = call_574079.validator(path, query, header, formData, body)
  let scheme = call_574079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574079.url(scheme.get, call_574079.host, call_574079.base,
                         call_574079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574079, url, valid)

proc call*(call_574150: Call_SubAssessmentsList_573879; apiVersion: string;
          assessmentName: string; scope: string): Recallable =
  ## subAssessmentsList
  ## Get security sub-assessments on all your scanned resources inside a scope
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   assessmentName: string (required)
  ##                 : The Assessment Key - Unique key for the assessment type
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_574151 = newJObject()
  var query_574153 = newJObject()
  add(query_574153, "api-version", newJString(apiVersion))
  add(path_574151, "assessmentName", newJString(assessmentName))
  add(path_574151, "scope", newJString(scope))
  result = call_574150.call(path_574151, query_574153, nil, nil, nil)

var subAssessmentsList* = Call_SubAssessmentsList_573879(
    name: "subAssessmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/assessments/{assessmentName}/subAssessments",
    validator: validate_SubAssessmentsList_573880, base: "",
    url: url_SubAssessmentsList_573881, schemes: {Scheme.Https})
type
  Call_SubAssessmentsGet_574192 = ref object of OpenApiRestCall_573657
proc url_SubAssessmentsGet_574194(protocol: Scheme; host: string; base: string;
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

proc validate_SubAssessmentsGet_574193(path: JsonNode; query: JsonNode;
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
  var valid_574195 = path.getOrDefault("assessmentName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "assessmentName", valid_574195
  var valid_574196 = path.getOrDefault("subAssessmentName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "subAssessmentName", valid_574196
  var valid_574197 = path.getOrDefault("scope")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "scope", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574199: Call_SubAssessmentsGet_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a security sub-assessment on your scanned resource
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_SubAssessmentsGet_574192; apiVersion: string;
          assessmentName: string; subAssessmentName: string; scope: string): Recallable =
  ## subAssessmentsGet
  ## Get a security sub-assessment on your scanned resource
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   assessmentName: string (required)
  ##                 : The Assessment Key - Unique key for the assessment type
  ##   subAssessmentName: string (required)
  ##                    : The Sub-Assessment Key - Unique key for the sub-assessment type
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "assessmentName", newJString(assessmentName))
  add(path_574201, "subAssessmentName", newJString(subAssessmentName))
  add(path_574201, "scope", newJString(scope))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var subAssessmentsGet* = Call_SubAssessmentsGet_574192(name: "subAssessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/assessments/{assessmentName}/subAssessments/{subAssessmentName}",
    validator: validate_SubAssessmentsGet_574193, base: "",
    url: url_SubAssessmentsGet_574194, schemes: {Scheme.Https})
type
  Call_SubAssessmentsListAll_574203 = ref object of OpenApiRestCall_573657
proc url_SubAssessmentsListAll_574205(protocol: Scheme; host: string; base: string;
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

proc validate_SubAssessmentsListAll_574204(path: JsonNode; query: JsonNode;
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
  var valid_574206 = path.getOrDefault("scope")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "scope", valid_574206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574207 = query.getOrDefault("api-version")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "api-version", valid_574207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574208: Call_SubAssessmentsListAll_574203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get security sub-assessments on all your scanned resources inside a subscription scope
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_SubAssessmentsListAll_574203; apiVersion: string;
          scope: string): Recallable =
  ## subAssessmentsListAll
  ## Get security sub-assessments on all your scanned resources inside a subscription scope
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  add(query_574211, "api-version", newJString(apiVersion))
  add(path_574210, "scope", newJString(scope))
  result = call_574209.call(path_574210, query_574211, nil, nil, nil)

var subAssessmentsListAll* = Call_SubAssessmentsListAll_574203(
    name: "subAssessmentsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Security/subAssessments",
    validator: validate_SubAssessmentsListAll_574204, base: "",
    url: url_SubAssessmentsListAll_574205, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
