
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "managementpartner-ManagementPartner"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationList_593648(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationList_593646; apiVersion: string): Recallable =
  ## operationList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : Supported version.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationList* = Call_OperationList_593646(name: "operationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/operations",
    validator: validate_OperationList_593647, base: "", url: url_OperationList_593648,
    schemes: {Scheme.Https})
type
  Call_PartnersGet_593942 = ref object of OpenApiRestCall_593424
proc url_PartnersGet_593944(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersGet_593943(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593945 = query.getOrDefault("api-version")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "api-version", valid_593945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593946: Call_PartnersGet_593942; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the management partner using the objectId and tenantId.
  ## 
  let valid = call_593946.validator(path, query, header, formData, body)
  let scheme = call_593946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593946.url(scheme.get, call_593946.host, call_593946.base,
                         call_593946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593946, url, valid)

proc call*(call_593947: Call_PartnersGet_593942; apiVersion: string): Recallable =
  ## partnersGet
  ## Get the management partner using the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  result = call_593947.call(nil, query_593948, nil, nil, nil)

var partnersGet* = Call_PartnersGet_593942(name: "partnersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.ManagementPartner/partners",
                                        validator: validate_PartnersGet_593943,
                                        base: "", url: url_PartnersGet_593944,
                                        schemes: {Scheme.Https})
type
  Call_PartnerCreate_593972 = ref object of OpenApiRestCall_593424
proc url_PartnerCreate_593974(protocol: Scheme; host: string; base: string;
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

proc validate_PartnerCreate_593973(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593975 = path.getOrDefault("partnerId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "partnerId", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_PartnerCreate_593972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a management partner for the objectId and tenantId.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_PartnerCreate_593972; apiVersion: string;
          partnerId: string): Recallable =
  ## partnerCreate
  ## Create a management partner for the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "partnerId", newJString(partnerId))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var partnerCreate* = Call_PartnerCreate_593972(name: "partnerCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerCreate_593973, base: "", url: url_PartnerCreate_593974,
    schemes: {Scheme.Https})
type
  Call_PartnerGet_593949 = ref object of OpenApiRestCall_593424
proc url_PartnerGet_593951(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PartnerGet_593950(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593966 = path.getOrDefault("partnerId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "partnerId", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_PartnerGet_593949; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the management partner using the partnerId, objectId and tenantId.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_PartnerGet_593949; apiVersion: string; partnerId: string): Recallable =
  ## partnerGet
  ## Get the management partner using the partnerId, objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_593970 = newJObject()
  var query_593971 = newJObject()
  add(query_593971, "api-version", newJString(apiVersion))
  add(path_593970, "partnerId", newJString(partnerId))
  result = call_593969.call(path_593970, query_593971, nil, nil, nil)

var partnerGet* = Call_PartnerGet_593949(name: "partnerGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
                                      validator: validate_PartnerGet_593950,
                                      base: "", url: url_PartnerGet_593951,
                                      schemes: {Scheme.Https})
type
  Call_PartnerUpdate_593990 = ref object of OpenApiRestCall_593424
proc url_PartnerUpdate_593992(protocol: Scheme; host: string; base: string;
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

proc validate_PartnerUpdate_593991(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593993 = path.getOrDefault("partnerId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "partnerId", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_PartnerUpdate_593990; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the management partner for the objectId and tenantId.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_PartnerUpdate_593990; apiVersion: string;
          partnerId: string): Recallable =
  ## partnerUpdate
  ## Update the management partner for the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "partnerId", newJString(partnerId))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var partnerUpdate* = Call_PartnerUpdate_593990(name: "partnerUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerUpdate_593991, base: "", url: url_PartnerUpdate_593992,
    schemes: {Scheme.Https})
type
  Call_PartnerDelete_593981 = ref object of OpenApiRestCall_593424
proc url_PartnerDelete_593983(protocol: Scheme; host: string; base: string;
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

proc validate_PartnerDelete_593982(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593984 = path.getOrDefault("partnerId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "partnerId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_PartnerDelete_593981; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the management partner for the objectId and tenantId.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_PartnerDelete_593981; apiVersion: string;
          partnerId: string): Recallable =
  ## partnerDelete
  ## Delete the management partner for the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "partnerId", newJString(partnerId))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var partnerDelete* = Call_PartnerDelete_593981(name: "partnerDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerDelete_593982, base: "", url: url_PartnerDelete_593983,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
