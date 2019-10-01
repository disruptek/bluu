
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "security-informationProtectionPolicies"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_InformationProtectionPoliciesList_567879 = ref object of OpenApiRestCall_567657
proc url_InformationProtectionPoliciesList_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesList_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Information protection policies of a specific management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568041 = path.getOrDefault("scope")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "scope", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_InformationProtectionPoliciesList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Information protection policies of a specific management group.
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_InformationProtectionPoliciesList_567879;
          apiVersion: string; scope: string): Recallable =
  ## informationProtectionPoliciesList
  ## Information protection policies of a specific management group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "scope", newJString(scope))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var informationProtectionPoliciesList* = Call_InformationProtectionPoliciesList_567879(
    name: "informationProtectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies",
    validator: validate_InformationProtectionPoliciesList_567880, base: "",
    url: url_InformationProtectionPoliciesList_567881, schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesCreateOrUpdate_568214 = ref object of OpenApiRestCall_567657
proc url_InformationProtectionPoliciesCreateOrUpdate_568216(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "informationProtectionPolicyName" in path,
        "`informationProtectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies/"), (
        kind: VariableSegment, value: "informationProtectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesCreateOrUpdate_568215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of the information protection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   informationProtectionPolicyName: JString (required)
  ##                                  : Name of the information protection policy.
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `informationProtectionPolicyName` field"
  var valid_568217 = path.getOrDefault("informationProtectionPolicyName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = newJString("effective"))
  if valid_568217 != nil:
    section.add "informationProtectionPolicyName", valid_568217
  var valid_568218 = path.getOrDefault("scope")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "scope", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_InformationProtectionPoliciesCreateOrUpdate_568214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_InformationProtectionPoliciesCreateOrUpdate_568214;
          apiVersion: string; scope: string;
          informationProtectionPolicyName: string = "effective"): Recallable =
  ## informationProtectionPoliciesCreateOrUpdate
  ## Details of the information protection policy.
  ##   informationProtectionPolicyName: string (required)
  ##                                  : Name of the information protection policy.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "scope", newJString(scope))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var informationProtectionPoliciesCreateOrUpdate* = Call_InformationProtectionPoliciesCreateOrUpdate_568214(
    name: "informationProtectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesCreateOrUpdate_568215,
    base: "", url: url_InformationProtectionPoliciesCreateOrUpdate_568216,
    schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesGet_568182 = ref object of OpenApiRestCall_567657
proc url_InformationProtectionPoliciesGet_568184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "informationProtectionPolicyName" in path,
        "`informationProtectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies/"), (
        kind: VariableSegment, value: "informationProtectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesGet_568183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of the information protection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   informationProtectionPolicyName: JString (required)
  ##                                  : Name of the information protection policy.
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `informationProtectionPolicyName` field"
  var valid_568207 = path.getOrDefault("informationProtectionPolicyName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = newJString("effective"))
  if valid_568207 != nil:
    section.add "informationProtectionPolicyName", valid_568207
  var valid_568208 = path.getOrDefault("scope")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "scope", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_InformationProtectionPoliciesGet_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_InformationProtectionPoliciesGet_568182;
          apiVersion: string; scope: string;
          informationProtectionPolicyName: string = "effective"): Recallable =
  ## informationProtectionPoliciesGet
  ## Details of the information protection policy.
  ##   informationProtectionPolicyName: string (required)
  ##                                  : Name of the information protection policy.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "scope", newJString(scope))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var informationProtectionPoliciesGet* = Call_InformationProtectionPoliciesGet_568182(
    name: "informationProtectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesGet_568183, base: "",
    url: url_InformationProtectionPoliciesGet_568184, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
