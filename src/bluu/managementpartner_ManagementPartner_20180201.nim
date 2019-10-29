
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ACE Provisioning ManagementPartner
## version: 2018-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## This API describe ACE Provisioning ManagementPartner
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
  macServiceName = "managementpartner-ManagementPartner"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationList_563779(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationList_563778(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationList_563777; apiVersion: string): Recallable =
  ## operationList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : Supported version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationList* = Call_OperationList_563777(name: "operationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/operations",
    validator: validate_OperationList_563778, base: "", url: url_OperationList_563779,
    schemes: {Scheme.Https})
type
  Call_PartnersGet_564075 = ref object of OpenApiRestCall_563555
proc url_PartnersGet_564077(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersGet_564076(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the management partner using the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564078 = query.getOrDefault("api-version")
  valid_564078 = validateParameter(valid_564078, JString, required = true,
                                 default = nil)
  if valid_564078 != nil:
    section.add "api-version", valid_564078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564079: Call_PartnersGet_564075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the management partner using the objectId and tenantId.
  ## 
  let valid = call_564079.validator(path, query, header, formData, body)
  let scheme = call_564079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564079.url(scheme.get, call_564079.host, call_564079.base,
                         call_564079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564079, url, valid)

proc call*(call_564080: Call_PartnersGet_564075; apiVersion: string): Recallable =
  ## partnersGet
  ## Get the management partner using the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  var query_564081 = newJObject()
  add(query_564081, "api-version", newJString(apiVersion))
  result = call_564080.call(nil, query_564081, nil, nil, nil)

var partnersGet* = Call_PartnersGet_564075(name: "partnersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.ManagementPartner/partners",
                                        validator: validate_PartnersGet_564076,
                                        base: "", url: url_PartnersGet_564077,
                                        schemes: {Scheme.Https})
type
  Call_PartnerCreate_564105 = ref object of OpenApiRestCall_563555
proc url_PartnerCreate_564107(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerCreate_564106(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a management partner for the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_564108 = path.getOrDefault("partnerId")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "partnerId", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_PartnerCreate_564105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a management partner for the objectId and tenantId.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_PartnerCreate_564105; partnerId: string;
          apiVersion: string): Recallable =
  ## partnerCreate
  ## Create a management partner for the objectId and tenantId.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  ##   apiVersion: string (required)
  ##             : Supported version.
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(path_564112, "partnerId", newJString(partnerId))
  add(query_564113, "api-version", newJString(apiVersion))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var partnerCreate* = Call_PartnerCreate_564105(name: "partnerCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerCreate_564106, base: "", url: url_PartnerCreate_564107,
    schemes: {Scheme.Https})
type
  Call_PartnerGet_564082 = ref object of OpenApiRestCall_563555
proc url_PartnerGet_564084(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerGet_564083(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the management partner using the partnerId, objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_564099 = path.getOrDefault("partnerId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "partnerId", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564100 = query.getOrDefault("api-version")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "api-version", valid_564100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_PartnerGet_564082; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the management partner using the partnerId, objectId and tenantId.
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_PartnerGet_564082; partnerId: string; apiVersion: string): Recallable =
  ## partnerGet
  ## Get the management partner using the partnerId, objectId and tenantId.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  ##   apiVersion: string (required)
  ##             : Supported version.
  var path_564103 = newJObject()
  var query_564104 = newJObject()
  add(path_564103, "partnerId", newJString(partnerId))
  add(query_564104, "api-version", newJString(apiVersion))
  result = call_564102.call(path_564103, query_564104, nil, nil, nil)

var partnerGet* = Call_PartnerGet_564082(name: "partnerGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
                                      validator: validate_PartnerGet_564083,
                                      base: "", url: url_PartnerGet_564084,
                                      schemes: {Scheme.Https})
type
  Call_PartnerUpdate_564123 = ref object of OpenApiRestCall_563555
proc url_PartnerUpdate_564125(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerUpdate_564124(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the management partner for the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_564126 = path.getOrDefault("partnerId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "partnerId", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_PartnerUpdate_564123; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the management partner for the objectId and tenantId.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_PartnerUpdate_564123; partnerId: string;
          apiVersion: string): Recallable =
  ## partnerUpdate
  ## Update the management partner for the objectId and tenantId.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  ##   apiVersion: string (required)
  ##             : Supported version.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(path_564130, "partnerId", newJString(partnerId))
  add(query_564131, "api-version", newJString(apiVersion))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var partnerUpdate* = Call_PartnerUpdate_564123(name: "partnerUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerUpdate_564124, base: "", url: url_PartnerUpdate_564125,
    schemes: {Scheme.Https})
type
  Call_PartnerDelete_564114 = ref object of OpenApiRestCall_563555
proc url_PartnerDelete_564116(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerDelete_564115(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the management partner for the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_564117 = path.getOrDefault("partnerId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "partnerId", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_PartnerDelete_564114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the management partner for the objectId and tenantId.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_PartnerDelete_564114; partnerId: string;
          apiVersion: string): Recallable =
  ## partnerDelete
  ## Delete the management partner for the objectId and tenantId.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  ##   apiVersion: string (required)
  ##             : Supported version.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(path_564121, "partnerId", newJString(partnerId))
  add(query_564122, "api-version", newJString(apiVersion))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var partnerDelete* = Call_PartnerDelete_564114(name: "partnerDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerDelete_564115, base: "", url: url_PartnerDelete_564116,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
